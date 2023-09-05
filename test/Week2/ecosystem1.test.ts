import { expect } from "chai";
import { ethers } from "hardhat";
import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
import { mine, time } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { Contract } from "hardhat/internal/hardhat-network/stack-traces/model";
import { getNameOfDeclaration } from "typescript";

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

    it("NFT pays royalty to receiver", async () => {
        const balanceBefore = await ethers.provider.getBalance(royaltyReceiver.address);
        await NFT.mint(other1.address, 1, [], 0, {value: price});

        const balanceAfter = await ethers.provider.getBalance(royaltyReceiver.address);
        
        expect(balanceAfter).to.be.gt(balanceBefore);
    });

    it("Stakers must wait 24 hours to mint tokens", async () => {
        const newTimestamp = (await ethers.provider.getBlock("latest"))!.timestamp + (24 * 60 * 60);
        await NFT.connect(other1).safeTransferFrom(other1.address, await instance.getAddress(), 1);
        await expect(instance.connect(other1).withdrawTokens()).to.be.revertedWith('Wait 24 hours');
        const balanceBefore = await erc20.balanceOf(other1.address);
        await time.increaseTo(newTimestamp);

        await instance.connect(other1).withdrawTokens();
        const balanceAfter = await erc20.balanceOf(other1.address);

        expect(balanceAfter).to.be.eq(balanceBefore + 10n);
    });

    it("The smart contract must take possession of the NFT and only the user should be able to withdraw it", async () => {
        expect(await NFT.ownerOf(1)).to.be.eq(await instance.getAddress());
        await expect(instance.connect(other2).withdrawNFT(1)).to.be.revertedWith('Not the original owner');

        await instance.connect(other1).withdrawNFT(1);
        expect(await NFT.ownerOf(1)).to.be.eq(other1.address);
    });
  
    it("Addresses inside merkle tree have discounted price", async () => {
        const proof = tree.getProof(index);
        await NFT.connect(other2).mint(other2.address, 2, proof, index, {value: price / 2n});

        expect(await NFT.balanceOf(other2.address)).to.be.eq(1);
    });
  
    it("NFT max supply is 20", async () => {
        const totalSupply = await NFT.totalSupply();

        for(let i = totalSupply; i < 20; i++){
            await NFT.mint(other1.address, i+1n, [], 0, {value: price});
        }

        await expect(NFT.mint(other1.address, 21, [], 0, {value: price})).to.be.revertedWith('Max supply reached already');

    });

    it("NFT owner can withdraw sales profit", async () => {

        const ownerBalance = await ethers.provider.getBalance(owner.address);

        await NFT.withdrawFunds();

        expect(await ethers.provider.getBalance(await NFT.getAddress())).to.be.eq(0);
        expect(await ethers.provider.getBalance(owner.address)).to.be.gt(ownerBalance);
     
    });
});