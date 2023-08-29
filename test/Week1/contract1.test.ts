import { expect } from "chai";
import { ethers } from "hardhat";
import { Contract1 } from "../typechain-types";

describe("Contract1", function () {
    let owner, banedUser;
    let instance: Contract1;
    before(async () => {
      instance = await ethers.deployContract("Contract1");

      [owner, banedUser] = await ethers.getSigners();
  
    });

    it("Only owner can ban account", async () => {
      await expect(instance.connect(banedUser).banAccount(owner.address)).to.be.revertedWith('Ownable: caller is not the owner');
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
        
        await expect(instance.banAccount(banedUser.address))
        .to.emit(instance, 'BanAccount')
        .withArgs(banedUser.address);
        
        // Cannot transfer
        const beforeBalance = await instance.balanceOf(banedUser.address);
        await expect(instance.connect(banedUser).transfer(owner.address, supply)).to.be.revertedWith('From is a sanctioned account');
        expect(await instance.balanceOf(banedUser.address)).to.be.eq(beforeBalance);
        
        // Cannot mint or be the recipient of minting
        await expect(instance.mint(banedUser.address, supply)).to.be.revertedWith('To is a sanctioned account');
        await expect(instance.connect(owner).mint(banedUser.address, supply)).to.be.revertedWith('To is a sanctioned account');
        
        // Cannot receive
        await expect(instance.transfer(banedUser.address, supply)).to.be.revertedWith('To is a sanctioned account');
        expect(await instance.balanceOf(banedUser.address)).to.be.eq(beforeBalance);
    });


    it("Account can only be banned once", async () => {
      await expect(instance.banAccount(banedUser.address)).to.be.revertedWith('Account already banned');
    });
  });