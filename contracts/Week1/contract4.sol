// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Checkpoints.sol";
import "hardhat/console.sol";

/// @title Untrusted escrow
/// @author Julissa Dantes
/// @notice A contract where a buyer can put an *arbitrary* ERC20 token into a contract and a seller can withdraw it 3 days later.
contract Contract4 {
    using Checkpoints for Checkpoints.Trace224;
    // account address => (token address => amount in time)
    mapping(address => mapping(address => Checkpoints.Trace224)) private usersFundsInTime;
    // account address => (token address => amount withdrawn)
    mapping(address => mapping(address => uint224)) public withdrawn;

    event Deposit(address indexed from, address indexed to, uint224 amount, address token);
    event Withdraw(address indexed to, uint224 amount, address token);

    /// @notice Returns the total amount of tokens sent to an address
    /// @param target The recipient of the funds
    /// @param token Token address
    function getTotalFundsByToken(address target, address token) external view returns (uint224) {
        return usersFundsInTime[target][token].latest();
    }

    /// @notice Allows to send tokens to recipient for the contract to hold for 3 days minimun
    /// @param target The recipient of the funds
    /// @param amount Token amount to be sent
    /// @param token Token address
    function deposit(address target, uint224 amount, address token) external {
        // transfer token to the contract
        require(ERC20(token).transferFrom(msg.sender, address(this), amount), "Transfer failed");
        //update state
        _push(usersFundsInTime[target][token], _add, amount);
        emit Deposit(msg.sender, target, amount, token);
    }

    /// @notice Allows to withdraw locked tokens if the time is up
    /// @param token Token address of tokens to withdraw
    function withdraw(address token) external {
        // The biggest timestamp that can fit a uint 32 is April 16, 2106, therefore this conversion wont cause problems
        uint32 time;
        unchecked {
            time = uint32(block.timestamp - 3 days);
        }
        uint224 totalWithdrawn = withdrawn[msg.sender][token];
        uint224 redimeableAmount = usersFundsInTime[msg.sender][token].upperLookupRecent(time);
        require(redimeableAmount > 0 && redimeableAmount > totalWithdrawn, "No available funds");
        uint224 availableAmount = redimeableAmount - totalWithdrawn;

        _push(usersFundsInTime[msg.sender][token], _subtract, availableAmount);
        withdrawn[msg.sender][token] = totalWithdrawn + availableAmount;
        require(ERC20(token).transfer(msg.sender, availableAmount), "Transfer failed");
        emit Withdraw(msg.sender, availableAmount, token);
    }

    /// @notice Manipulates the tokens available in time by adding or removing
    /// @param store Checkpoints by account
    /// @param op operation to be performed
    /// @param delta the increment/decrement amount
    function _push(
        Checkpoints.Trace224 storage store,
        function(uint224, uint224) view returns (uint224) op,
        uint224 delta
    ) private returns (uint224, uint224) {
        return store.push(SafeCast.toUint32(block.timestamp), op(store.latest(), delta));
    }

    function _add(uint224 a, uint224 b) private pure returns (uint224) {
        return a + b;
    }

    function _subtract(uint224 a, uint224 b) private pure returns (uint224) {
        return a - b;
    }
}
