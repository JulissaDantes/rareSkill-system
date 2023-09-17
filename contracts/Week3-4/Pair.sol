// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import {IPair} from "./interfaces/IPair.sol";
import {ICallee} from "./interfaces/ICallee.sol";
import {IFactory} from "./interfaces/IFactory.sol";
import {IERC3156FlashLender} from "./interfaces/IERC3156FlashLender.sol";
import {IERC3156FlashBorrower} from "./interfaces/IERC3156FlashBorrower.sol";
import {Math} from "./libraries/Math.sol";
import {MyPairedToken, IERC20} from "./ERC20.sol";
// OpenZeppelin version used: 4.9.3
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "prb-math/contracts/PRBMathSD59x18.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "hardhat/console.sol";

contract Pair is IPair, MyPairedToken, ReentrancyGuard, IERC3156FlashLender {
    using PRBMathSD59x18 for uint224;
    using SafeERC20 for IERC20;

    uint256 public constant MINIMUM_LIQUIDITY = 10;
    uint256 public constant FLASH_FEE = 1;
    bytes4 private constant SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));

    address public factory;
    address public token0;
    address public token1;

    uint112 private reserve0; // uses single storage slot, accessible via getReserves
    uint112 private reserve1; // uses single storage slot, accessible via getReserves
    uint32 private blockTimestampLast; // uses single storage slot, accessible via getReserves

    uint256 public price0CumulativeLast;
    uint256 public price1CumulativeLast;
    uint256 public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event

    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    event FlashSwap(address indexed receiver, address indexed token, uint256 amount);

    constructor() {
        factory = msg.sender;
    }

    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, "FORBIDDEN"); // sufficient check
        token0 = _token0;
        token1 = _token1;
    }

    /// @dev An ERC3156 based implementation of a flash swap. The difference between a normal swap is that instead
    /// of giving the token they are are trying to swap before the swap its performed in the callback function
    /// as `payment` for the loaned token.
    /// @param receiver the address of the token recipient.
    /// @param token the token address user wants to borrow. Must match the address of token0 or token1.
    /// @param amount The amount of tokens lend.
    /// @param data A data parameter to be passed on to the `receiver` for any custom use.
    function flashLoan(
        IERC3156FlashBorrower receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) external returns (bool) {
        address _token0 = token0;
        address _token1 = token1;
        require(token == _token0 || token == _token1, "Unsupported currency");
        address tokenOut = token == _token0 ? _token0 : _token1;
        address tokenIn = tokenOut == _token0 ? _token1 : _token0;
        IERC20(tokenOut).safeTransfer(address(receiver), amount);
        // The fee takes into consideration the amount given to the receipient
        uint256 AmountIn = _flashFee(token, amount);
        require(
            receiver.onFlashLoan(msg.sender, token, amount, AmountIn, data) ==
                keccak256("ERC3156FlashBorrower.onFlashLoan"),
            "IERC3156: Callback failed"
        );
        // collect tokens
        uint256 _allowance = IERC20(tokenIn).allowance(address(receiver), address(this));
        require(_allowance >= (AmountIn), "Repay not approved");

        require(IERC20(tokenIn).transferFrom(address(receiver), address(this), AmountIn), "Repay failed");

        //update reserves
        sync();
        emit FlashSwap(address(receiver), token, amount);

        return true;
    }

    /// @dev Returns the maximun amount of tokens to loan.
    /// @param token token to check.
    function maxFlashLoan(address token) external view override returns (uint256) {
        return IERC20(token).balanceOf(address(this));
    }

    /// @dev Returns the amount of tokens the user must transfer to repay the loan.
    /// @param token token to check.
    /// @param amount amount loaned.
    function flashFee(address token, uint256 amount) external view returns (uint256) {
        require(token == token0 || token == token1, "Unsupported currency");
        return _flashFee(token, amount);
    }

    /// @dev update reserves and, on the first call per block, price accumulators.
    function _update(uint256 balance0, uint256 balance1, uint112 _reserve0, uint112 _reserve1) private {
        require(balance0 <= type(uint112).max && balance1 <= type(uint112).max, "OVERFLOW");
        uint32 blockTimestamp = uint32(block.timestamp % 2 ** 32);
        // overflow is desired the timestamp values are expected to increase over time, and an overflow in the timeElapsed
        //  calculation simply indicates that a significant amount of time has passed since the last update
        uint32 timeElapsed = blockTimestamp - blockTimestampLast;

        if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
            /* for clarity this is what is going on in the next lines:
            price0CumulativeLast += (_reserve1 / _reserve0) * timeElapsed;
            price1CumulativeLast += (_reserve0 / _reserve1) * timeElapsed;*/

            // * never overflows, and + overflow is desired
            // The formulas used here are related to the ratio of token balances over time.
            price0CumulativeLast +=
                uint(
                    PRBMathSD59x18.toInt(
                        PRBMathSD59x18.div(
                            PRBMathSD59x18.fromInt(int256(uint256(_reserve1))),
                            PRBMathSD59x18.fromInt(int256(uint256(_reserve0)))
                        )
                    )
                ) *
                timeElapsed;
            price1CumulativeLast +=
                uint(
                    PRBMathSD59x18.toInt(
                        PRBMathSD59x18.div(
                            PRBMathSD59x18.fromInt(int256(uint256(_reserve0))),
                            PRBMathSD59x18.fromInt(int256(uint256(_reserve1)))
                        )
                    )
                ) *
                timeElapsed;
        }
        reserve0 = uint112(balance0);
        reserve1 = uint112(balance1);
        blockTimestampLast = blockTimestamp;
        emit Sync(reserve0, reserve1);
    }

    /// @dev this low-level function should be called from a contract which performs important safety checks.
    function mint(address to) external nonReentrant returns (uint256 liquidity) {
        (uint112 _reserve0, uint112 _reserve1, ) = getReserves(); // gas savings
        uint256 balance0 = IERC20(token0).balanceOf(address(this));
        uint256 balance1 = IERC20(token1).balanceOf(address(this));
        uint256 amount0 = balance0 - _reserve0;
        uint256 amount1 = balance1 - _reserve1;

        bool feeOn = _mintFee(_reserve0, _reserve1);

        uint256 _totalSupply = totalSupply(); // must be defined here since totalSupply can update in _mintFee
        if (_totalSupply == 0) {
            require(Math.sqrt(amount0 * amount1) > MINIMUM_LIQUIDITY, "Invalid token balances");
            liquidity = Math.sqrt(amount0 * amount1) - MINIMUM_LIQUIDITY;
            _mint(address(this), MINIMUM_LIQUIDITY); // permanently  nonReentrant the first MINIMUM_LIQUIDITY tokens
        } else {
            liquidity = Math.min((amount0 * _totalSupply) / _reserve0, (amount1 * _totalSupply) / _reserve1);
        }
        require(liquidity > 0, "INSUFFICIENT_LIQUIDITY_MINTED");
        _mint(to, liquidity);

        _update(balance0, balance1, _reserve0, _reserve1);
        if (feeOn) kLast = reserve0 * reserve1; // reserve0 and reserve1 are up-to-date
    }

    /// @dev this low-level function should be called from a contract which performs important safety checks.
    /// @param to owner of tokens.
    function burn(address to) external nonReentrant returns (uint256 amount0, uint256 amount1) {
        (uint112 _reserve0, uint112 _reserve1, ) = getReserves(); // gas savings
        address _token0 = token0; // gas savings
        address _token1 = token1; // gas savings
        uint256 balance0 = IERC20(_token0).balanceOf(address(this));
        uint256 balance1 = IERC20(_token1).balanceOf(address(this));
        uint256 liquidity = balanceOf(address(this));

        bool feeOn = _mintFee(_reserve0, _reserve1);
        uint256 _totalSupply = totalSupply(); // gas savings, must be defined here since totalSupply can update in _mintFee
        amount0 = (liquidity * balance0) / _totalSupply; // using balances ensures pro-rata distribution
        amount1 = (liquidity * balance1) / _totalSupply; // using balances ensures pro-rata distribution
        require(amount0 > 0 && amount1 > 0, "INSUFFICIENT_LIQUIDITY_BURNED");
        _burn(to, liquidity);
        IERC20(_token0).safeTransfer(to, amount0);
        IERC20(_token1).safeTransfer(to, amount1);
        balance0 = IERC20(_token0).balanceOf(address(this));
        balance1 = IERC20(_token1).balanceOf(address(this));

        _update(balance0, balance1, _reserve0, _reserve1);
        if (feeOn) kLast = uint(reserve0) * reserve1; // reserve0 and reserve1 are up-to-date
    }

    /// @dev this low-level function should be called from a contract which performs important safety checks.
    /// @param amount0Out amount of token0 that to receives.
    /// @param amount1Out amount of token1 that to receives.
    /// @param to recipeint of tokens.
    /// @param data A data parameter to be passed on to the `receiver` for any custom use.
    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external nonReentrant {
        require(amount0Out > 0 || amount1Out > 0, "INSUFFICIENT_OUTPUT_AMOUNT");
        (uint112 _reserve0, uint112 _reserve1, ) = getReserves(); // gas savings
        require(amount0Out < _reserve0 && amount1Out < _reserve1, "INSUFFICIENT_LIQUIDITY");

        uint256 balance0;
        uint256 balance1;
        {
            // scope for _token{0,1}, avoids stack too deep errors
            address _token0 = token0;
            address _token1 = token1;
            require(to != _token0 && to != _token1, "INVALID_TO");
            if (amount0Out > 0) IERC20(_token0).safeTransfer(to, amount0Out); // optimistically transfer tokens
            if (amount1Out > 0) IERC20(_token1).safeTransfer(to, amount1Out); // optimistically transfer tokens
            if (data.length > 0) ICallee(to).Call(msg.sender, amount0Out, amount1Out, data);
            balance0 = IERC20(_token0).balanceOf(address(this));
            balance1 = IERC20(_token1).balanceOf(address(this));
        }
        uint256 amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
        uint256 amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;

        require(amount0In > 0 || amount1In > 0, "INSUFFICIENT_INPUT_AMOUNT");
        {
            // scope for reserve{0,1}Adjusted, avoids stack too deep errors
            uint256 balance0Adjusted = (balance0 * 1000) - (amount0In * 3);
            uint256 balance1Adjusted = (balance1 * 1000) - (amount1In * 3);
            require(balance0Adjusted * balance1Adjusted >= _reserve0 * _reserve1 * (1000 ** 2), "K");
        }

        _update(balance0, balance1, _reserve0, _reserve1);
        emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
    }

    /// @dev force balances to match reserves.
    /// @param to receiver of extra balance.
    function skim(address to) external nonReentrant {
        address _token0 = token0; // gas savings
        address _token1 = token1; // gas savings
        IERC20(_token0).safeTransfer(to, IERC20(_token0).balanceOf(address(this)) - reserve0);
        IERC20(_token1).safeTransfer(to, IERC20(_token1).balanceOf(address(this)) - reserve1);
    }

    /// @dev Returns the reserve amounts for each token and the last block timestamp from last update.
    function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
        _reserve0 = reserve0;
        _reserve1 = reserve1;
        _blockTimestampLast = blockTimestampLast;
    }

    /// @dev force reserves to match balances.
    function sync() public nonReentrant {
        _update(IERC20(token0).balanceOf(address(this)), IERC20(token1).balanceOf(address(this)), reserve0, reserve1);
    }

    function _flashFee(address token, uint256 amount) internal view returns (uint256) {
        if (token == token0) {
            //fix this to make more sense in terms of ratio TODO
            return (amount * FLASH_FEE) / 10000;
        } else {
            return (amount * FLASH_FEE) / 10;
        }
    }
    
    /// @dev if fee is on, mint liquidity equivalent to 1/6th of the growth in sqrt(k)
    /// @param _reserve0 balance of token0.
    /// @param _reserve1 balance of token1.
    function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {
        address feeTo = IFactory(factory).feeTo();
        feeOn = feeTo != address(0);
        uint256 _kLast = kLast; // gas savings
        if (feeOn) {
            if (_kLast != 0) {
                uint256 rootK = Math.sqrt(uint(_reserve0) * _reserve1);
                uint256 rootKLast = Math.sqrt(_kLast);
                if (rootK > rootKLast) {
                    uint256 root = rootK - rootKLast;
                    uint256 numerator = totalSupply() * root;
                    uint256 denominator = rootK * 5 + rootKLast;
                    uint256 liquidity = numerator / denominator;
                    if (liquidity > 0) _mint(feeTo, liquidity);
                }
            }
        } else if (_kLast != 0) {
            kLast = 0;
        }
    }
}
