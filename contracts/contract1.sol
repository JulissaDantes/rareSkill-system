// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/access/Ownable2Step.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/*
* Token with sanctions. A fungible token that allows an admin to ban specified addresses from sending and receiving tokens.
*/
contract Contract1 is Ownable2Step, ERC20("SanctionableToken", "STK") {
    mapping(address => bool) bannedAddresses;

    function banAccount(address account) external onlyOwner {
        bannedAddresses[account] = true;
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        require(!bannedAddresses[from] && !bannedAddresses[to], "Sanctioned account");
        super._beforeTokenTransfer(from, to, amount);
    }

}
