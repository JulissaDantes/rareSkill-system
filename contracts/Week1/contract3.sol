// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {IERC1363Receiver} from "erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol";
import {BuyToken} from "./ERC1363.sol";
import {SellToken} from "./ERC20.sol";
import "hardhat/console.sol";

/// @title Token sale and buyback with bonding curve
/// @author Julissa Dantes
/// @notice The more tokens a user buys, the more expensive the token becomes. To keep things simple, use a linear bonding curve. When a person
/// sends a token to the contract with ERC1363 or ERC777, it should trigger the receive function. If you use a separate contract to handle the
/// reserve and use ERC20, you need to use the approve and send workflow. This should support fractions of tokens.
///
/// NOTE: This contracts locks the ERC1363 tokens used to buy the ERC20, it should have a transfer mechanism to about locking the tokens in,
/// but the contract focus only on the token sale using the linear bonding curve to compute the price. I DO NOT RECOMMEND DEPLOYING TO PRODUCTION.
contract Contract3 is IERC1363Receiver, ReentrancyGuard {
    // linear bonding curve growth rate
    uint256 public immutable slope;
    // initial token price
    uint256 public immutable initialPrice;
    // Token for sale
    SellToken public tokenA;
    // Token to buy tokenA with
    BuyToken public tokenB;

    // To prevent sandwich attacks there will be a cooldown after buy and sell
    uint256 constant COOLDOWN_TIME = 1 days;
    // The accounts on cooldown will be here
    mapping(address => uint32) private _cooldownAccounts;

    event SellTokens(address indexed seller, uint256 amount, uint256 price);
    event BuyTokens(address indexed buyer, uint256 amount, uint256 price);

    constructor(uint256 _slope, uint256 _initialPrice, address _tokenB) {
        slope = _slope;
        initialPrice = _initialPrice;
        tokenA = new SellToken();
        tokenB = BuyToken(_tokenB);
    }

    function getTokenAAddress() external view returns (address) {
        return address(tokenA);
    }

    /// @notice Allows accounts to sell their tokens A for tokens B. Account needs to cooldown before buying again
    /// @param amount The amount of tokens to sell
    function sellTokens(uint256 amount) external nonReentrant {
        require(
            _cooldownAccounts[msg.sender] <= uint32(block.timestamp),
            "Please wait until the cooldown period expires"
        );
        require(tokenA.balanceOf(msg.sender) >= amount, "Invalid sell amount");
        uint256 price = getPrice();
        uint256 tokenBAmount = price * amount;

        // If not enough players participate in the ecosystem, tokens to be paid might be higher than tokens
        // available, thefore the selling process has its limits.
        require(tokenBAmount < tokenB.balanceOf(address(this)), "Sell amount is bigger than max sell limit");

        require(tokenB.transfer(msg.sender, tokenBAmount), "Transfer failed");
        tokenA.burn(msg.sender, amount);
        _cooldownAccounts[msg.sender] = uint32(block.timestamp + COOLDOWN_TIME);
        emit SellTokens(msg.sender, tokenBAmount, price);
    }

    /// @notice Allows accounts to buy tokens A with tokens B.
    /// @param amount The amount of tokens to minted
    function onTransferReceived(
        address,
        address sender,
        uint256 amount,
        bytes memory
    ) public override returns (bytes4) {
        require(msg.sender == address(tokenB), "Only transfers can trigger this function");
        require(_cooldownAccounts[sender] <= uint32(block.timestamp), "Please wait until the cooldown period expires");
        uint256 price = getPrice();
        uint256 tokenAmount = amount / price;
        require(tokenAmount > 0, "Not enough tokens to buy");
        tokenA.mint(sender, tokenAmount);

        // If payment was not exact returns unused amount
        if (amount != tokenAmount * price) {
            require(tokenB.transfer(sender, amount - (tokenAmount * price)), "Transfer failed");
        }

        _cooldownAccounts[msg.sender] = uint32(block.timestamp + COOLDOWN_TIME);
        emit BuyTokens(sender, tokenAmount, price);
        return IERC1363Receiver.onTransferReceived.selector;
    }

    /// @notice Returns current price of token A using linear bonding curve formula to return the price,
    /// price = (slope * tokenSupply) + initialPrice.
    function getPrice() public view returns (uint256) {
        return (slope + tokenA.totalSupply()) + initialPrice;
    }
}
