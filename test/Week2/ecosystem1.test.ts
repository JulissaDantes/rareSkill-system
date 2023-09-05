import { expect } from "chai";
import { ethers } from "hardhat";
import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
import { mine, time } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { Contract } from "hardhat/internal/hardhat-network/stack-traces/model";

describe.only("Ecosystem 1", function () {
    let owner, other1, other2, royaltyReceiver, lastTokenID, tree, index = 0, price = ethers.parseEther("100.0");
    let instance: Contract;
    let erc20: Contract;
    let NFT: Contract;
    before(async () => {

        [owner, other1, other2, royaltyReceiver] = await ethers.getSigners();
        const discountAddresses = [
            [other2.address, index]
          ];
          
        tree = StandardMerkleTree.of(discountAddresses, ["address", "uint256"]);
  
        NFT = await ethers.deployContract("NFT", [tree.root, price, royaltyReceiver.address]);
        instance = await ethers.deployContract("StakeNFT", [NFT.getAddress()]);
        const erc20Contract = await ethers.getContractFactory("SellToken");
        erc20 = erc20Contract.attach(await instance.getTokenAddress());
      
    });

    it("Merkle verify works", async () => {
        const proof = tree.getProof(index);
        expect(await NFT.verify(proof, other2.address, index)).to.be.true;
        expect(await NFT.verify(proof, other1.address, index)).to.be.false;
    });

    it("NFT pays 2.5% of its price to royalty receiver", async () => {
        const payment = price * 0.025;
        const balanceBefore = await ethers.provider.getBalance(royaltyReceiver.address);

        const balanceAfter = await ethers.provider.getBalance(royaltyReceiver.address);
    });

    it("Stakers must wait 24 hours to mint tokens", async () => {
     
    });
  
    it("Addresses inside merkle tree have discounted price", async () => {
     
    });
  
    it("NFT max supply is 20", async () => {
     
    });

    it("NFT owner can withdraw sales profit", async () => {
     
    });

    it("The smart contract must take possession of the NFT and only the user should be able to withdraw it", async () => {
     
    });
});