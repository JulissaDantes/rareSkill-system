// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title ERC to sell
/// @author Julissa Dantes
/// @dev A mintable and burnable ERC20 where only the owner can performed the mentioned functions.
contract SellERC is Ownable2Step, ERC20("SellERC", "SER") {
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }
}
