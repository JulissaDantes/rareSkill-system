// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/access/Ownable2Step.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title Token with sanctions
/// @author Julissa Dantes
/// @notice A fungible token that allows an admin to ban specified addresses from sending and receiving tokens.
contract Contract1 is Ownable2Step, ERC20("SanctionableToken", "STK") {
    mapping(address => bool) bannedAddresses;

    /// @notice ban specific account ERC20 tokens
    /// @param account The account to be banned
    function banAccount(address account) external onlyOwner {
        bannedAddresses[account] = true;
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    /// @notice Override of before token transfer hook to include check for anned accounts
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        require(!bannedAddresses[from] && !bannedAddresses[to], "Sanctioned account");
        super._beforeTokenTransfer(from, to, amount);
    }
}
