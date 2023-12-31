// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/access/Ownable2Step.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title Token with sanctions
/// @author Julissa Dantes
/// @dev A fungible token that allows an admin to ban specified addresses from sending and receiving tokens.
contract Contract1 is Ownable2Step, ERC20("SanctionableToken", "STK") {
    mapping(address => bool) internal bannedAddresses;

    event BanAccount(address indexed);

    /// @dev ban specific account ERC20 tokens. Once an account its banned it cannot be un-banned.
    /// @param account The account to be banned
    function banAccount(address account) external onlyOwner {
        require(!bannedAddresses[account], "Account already banned");
        bannedAddresses[account] = true;
        emit BanAccount(account);
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    /// @dev Override of before token transfer hook to include check for anned accounts
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        require(!bannedAddresses[from], "From is a sanctioned account");
        require(!bannedAddresses[to], "To is a sanctioned account");
        super._beforeTokenTransfer(from, to, amount);
    }
}
