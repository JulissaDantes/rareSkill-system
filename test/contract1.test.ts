import { expect } from "chai";
import { ethers } from "hardhat";
import { Contract } from "ethers";

describe("Contract1", function () {
    let owner, banedUser;
    let instance: Contract;
    before(async () => {
      const ContractFactory = await ethers.getContractFactory("Contract1");
  
      instance = await ContractFactory.deploy();
      await instance.deployed();

      [owner, banedUser] = await ethers.getSigners();
  
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
        expect(await instance.symbol()).to.be.eq("STK");
    });
  });