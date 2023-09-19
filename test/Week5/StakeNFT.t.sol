// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "forge-std/Test.sol";
import "lib/murky/src/Merkle.sol";
import {StakeNFT} from "../../contracts/Week2/Ecosystem1/StakeNFT.sol";
import {NFT} from "../../contracts/Week2/Ecosystem1/NFT.sol";

contract StakeNFTTest is Test {
    StakeNFT public stakeNFT;
    NFT public nft;
    uint256 immutable price = 10;

    function setUp() public {
        // Initialize
        Merkle m = new Merkle();
        // Toy Data
        bytes32[] memory data = [bytes32(msg.sender)];
        // Get Root, Proof, and Verify
        bytes32 root = m.getRoot(data, 0);

        nft = new NFT(root, price, msg.sender);
        stakeNFT = new StakeNFT(address(nft));
    }

    //Merkle verify works
    function testMerkleVerify() {
        assertEq(counter.number(), 1);
    }
    
    // NFT pays royalty to receiver
    // Stakers must wait 24 hours to mint tokens (52ms)
    // The smart contract must take possession of the NFT and only the user should be able to withdraw it
    // Addresses inside merkle tree have discounted price
    // Addresses inside merkle cannot claim more than one
    // NFT max supply is 20 (145ms)
    // NFT owner can withdraw sales profit
}