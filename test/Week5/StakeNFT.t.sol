// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "forge-std/Test.sol";
import {Merkle} from "lib/murky/src/Merkle.sol";
import {StakeNFT} from "../../contracts/Week2/Ecosystem1/StakeNFT.sol";
import {NFT} from "../../contracts/Week2/Ecosystem1/NFT.sol";
import {SellERC} from "../../contracts/Week2/Ecosystem1/ERC20.sol";
import "forge-std/console.sol";

contract StakeNFTTest is Test {
    StakeNFT public stakeNFT;
    NFT public nft;
    SellERC public erc20;
    uint256 immutable public price = 100;
    Merkle m = new Merkle();
    bytes32 public root;
    uint256 immutable public index = 0;
    uint256 immutable tokenId = 1;
    bytes32[] data = new bytes32[](4);
    address immutable public other = address(1234);
    address immutable public royaltyReceiver = address(12346);

    function setUp() public {
        // Toy Data
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(msg.sender, index))));
        data[0] = leaf;
        data[1] = bytes32("0x1");
        data[2] = bytes32("0x2");
        data[3] = bytes32("0x3");
        // Get Root, Proof, and Verify
        root = m.getRoot(data);
        vm.startPrank(msg.sender);
        nft = new NFT(root, price, royaltyReceiver);
        stakeNFT = new StakeNFT(address(nft));

        erc20 = SellERC(stakeNFT.getTokenAddress());
        vm.stopPrank();
    }

    //Merkle verify works
    function testMerkleVerify() public {
        bytes32[] memory proof = m.getProof(data, index);
        bool result = nft.verify(proof ,msg.sender, index);
        assertEq(result, true);
    }

    // NFT pays royalty to receiver
    function testRoyaltyPayment() public {
        uint256 balanceBefore = royaltyReceiver.balance;
        vm.startPrank(other);
        vm.deal(other, price);
        nft.mint{value: price}(other, 10, data, index);
        vm.stopPrank();
        assertGt(royaltyReceiver.balance, balanceBefore);
    }

    // Stakers must wait 24 hours to mint tokens (52ms)
    function testDelay() public {
        uint256 balanceBefore = erc20.balanceOf(msg.sender);
        nft.mint{value: price}(msg.sender, tokenId, data, index);

        vm.startPrank(msg.sender);
        nft.approve(address(stakeNFT), tokenId);
        nft.safeTransferFrom(msg.sender, address(stakeNFT), tokenId);


        //expect revert
        vm.expectRevert("Wait 24 hours");
        stakeNFT.withdrawTokens();

        //advance time
        vm.warp(block.timestamp + 1 days);

        //allow withdraw
        stakeNFT.withdrawTokens();
        vm.stopPrank();
        assertGt(erc20.balanceOf(msg.sender), balanceBefore);

    }

    // The smart contract must take possession of the NFT and only the user should be able to withdraw it
    function testStake() public {
        nft.mint{value: price}(msg.sender, tokenId, data, index);

        vm.startPrank(msg.sender);
        nft.approve(address(stakeNFT), tokenId);
        nft.safeTransferFrom(msg.sender, address(stakeNFT), tokenId);
        assertEq(nft.ownerOf(tokenId), address(stakeNFT));
        vm.stopPrank();

        vm.expectRevert("Not the original owner");
        stakeNFT.withdrawNFT(tokenId);

        vm.startPrank(msg.sender);
        stakeNFT.withdrawNFT(tokenId);
        assertEq(nft.ownerOf(tokenId), msg.sender);
        vm.stopPrank();
    }

    // Addresses inside merkle tree have discounted price
    function testMerkleAddress() public {
        vm.startPrank(msg.sender);
        bytes32[] memory proof = m.getProof(data, index);
        nft.mint{value: price / 2}(msg.sender, tokenId, proof, index);
        vm.stopPrank();

        assertEq(nft.ownerOf(tokenId), msg.sender);
    }

    // Addresses inside merkle cannot claim more than one
    function testOnlyClaimOnce() public {
        vm.startPrank(msg.sender);
        bytes32[] memory proof = m.getProof(data, index);
        nft.mint{value: price / 2}(msg.sender, tokenId, proof, index);


        vm.expectRevert("Already claimed");
        nft.mint{value: price / 2}(msg.sender, tokenId, proof, index);
        vm.stopPrank();


        assertEq(nft.ownerOf(tokenId), msg.sender);
    }

    // NFT max supply is 20 (145ms)
    function testMaxSupply() public {
        uint256 limit = 20;
       
        for(uint256 i = 0; i < limit; i++) {
            nft.mint{value: price}(other, i + 1, data, index);
        }

        vm.expectRevert("Max supply reached already");
        nft.mint{value: price}(other, limit + 1, data, index);

    }

    // NFT owner can withdraw sales profit
    function testWithdraw() public {
        uint256 balanceBefore = msg.sender.balance;
        vm.startPrank(other);
        vm.deal(other, price);
        nft.mint{value: price}(other, 10, data, index);
        vm.stopPrank();

        uint256 funds = address(nft).balance;
        vm.startPrank(msg.sender);
        nft.withdrawFunds();
        vm.stopPrank();

        assertEq(address(nft).balance, 0);
        assertEq(msg.sender.balance, funds + balanceBefore);
    }

}