import { expect } from "chai";
import { ethers } from "hardhat";
import { Contract2 } from "../typechain-types";

describe("Contract2", function () {
    let owner, other1, other2;
    let instance: Contract2;
    const supply = 10;
    this.beforeEach(async () => {
        [owner, other1, other2] = await ethers.getSigners();
        instance = await ethers.deployContract("Contract2", [owner.address]);

        instance.mint(other1, supply);
    });
  
    it("God account can transfer between 2 accounts without allowance", async () => {

        await instance.customTransfer(other1, other2, supply);
        
        expect(await instance.balanceOf(other2)).to.be.eq(supply);
        expect(await instance.balanceOf(other1)).to.be.eq(0);
    });

    it("God account can transfer between 2 accounts with exact allowance", async () => {
        await instance.connect(other1).approve(other2, supply);
        await instance.customTransfer(other1, other2, supply);

        expect(await instance.balanceOf(other2)).to.be.eq(supply);
        expect(await instance.balanceOf(other1)).to.be.eq(0);
        expect(await instance.allowance(other1, other2)).to.be.eq(0);
    });

    it("God account can transfer between 2 accounts with less allowance", async () => {
        await instance.connect(other1).approve(other2, supply / 2);
        await instance.customTransfer(other1, other2, supply);
        
        expect(await instance.balanceOf(other2)).to.be.eq(supply);
        expect(await instance.balanceOf(other1)).to.be.eq(0);
        expect(await instance.allowance(other1, other2)).to.be.eq(0);
    });

    it("God account can transfer between 2 accounts with more allowance", async () => {
        const value = supply / 2;
        await instance.connect(other1).approve(other2, supply);
        const allowanceBefore = await instance.allowance(other1, other2);
        await instance.customTransfer(other1, other2, value);
        
        expect(await instance.balanceOf(other2)).to.be.eq(value);
        expect(await instance.balanceOf(other1)).to.be.eq(value);
        expect(await instance.allowance(other1, other2)).to.be.eq(Number(allowanceBefore) - value);
    });

  });