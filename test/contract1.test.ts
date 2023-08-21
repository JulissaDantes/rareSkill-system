import { expect } from "chai";
import { ethers } from "hardhat";
import { Contract } from "ethers";

describe("Contract1", function () {
    let owner, banedUser;
    let instance: Contract;
    before(async () => {
      instance = await ethers.deployContract("Contract1");

      [owner, banedUser] = await ethers.getSigners();
  
    });

    it("Only owner can ban account", async () => {
      expect(instance.connect(banedUser).banAccount(owner.address)).to.be.revertedWith('Ownable: caller is not the owner');
    });
  
    it("Un-banned account can handle tokens", async () => {
        const supply = 10;
        // Can mint
        await instance.connect(banedUser).mint(banedUser.address, supply);
        expect(await instance.balanceOf(banedUser.address)).to.be.eq(supply);

        // Can transfer
        await instance.connect(banedUser).transfer(owner.address, supply);
        expect(await instance.balanceOf(banedUser.address)).to.be.eq(0);
        expect(await instance.balanceOf(owner.address)).to.be.eq(supply);

        // Can receive
        await instance.transfer(banedUser.address, supply);
        expect(await instance.balanceOf(banedUser.address)).to.be.eq(supply);
        expect(await instance.balanceOf(owner.address)).to.be.eq(0);
    });

    it("Banned account cannot handle tokens", async () => {
        const supply = 10;
        
        await instance.mint(banedUser.address, supply);
        await instance.mint(owner.address, supply);
        
        await instance.banAccount(banedUser.address);
    
        // Cannot transfer
        const beforeBalance = await instance.balanceOf(banedUser.address);
        expect(instance.connect(banedUser).transfer(owner.address, supply)).to.be.revertedWith('Sanctioned account');
        expect(await instance.balanceOf(banedUser.address)).to.be.eq(beforeBalance);
        
        // Cannot mint or be the recipient of minting
        expect(instance.mint(banedUser.address, supply)).to.be.revertedWith('Sanctioned account');
        expect(instance.connect(owner).mint(banedUser.address, supply)).to.be.revertedWith('Sanctioned account');
        
        // Cannot receive
        expect(instance.transfer(banedUser.address, supply)).to.be.revertedWith('Sanctioned account');
        expect(await instance.balanceOf(banedUser.address)).to.be.eq(beforeBalance);
    });
  });