// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SellToken is Ownable2Step, ERC20("SellToken", "STK") {
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }
}
