// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "forge-std/Test.sol";
import {SellERC} from "../../contracts/Week2/Ecosystem1/ERC20.sol";

contract SellERCTest is Test {
    SellERC public sellERC;

    function setUp() public {
        sellERC = new SellERC();
    }
}