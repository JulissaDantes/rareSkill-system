import { expect } from "chai";
import { ethers } from "hardhat";

describe("Ecosystem 2", function () {
    let owner;
    let instance: Game;
    let token: MyEnumerableToken
    before(async () => {
      token = await ethers.deployContract("MyEnumerableToken");
      instance = await ethers.deployContract("Game", [await token.getAddress()]);
      
      [owner] = await ethers.getSigners();
      for(let i = 0; i <= 20; i++) {
        await token.mint(owner.address);
      }
    });
  
    it("Can count prime tokenIds", async () => {
      // There are 8 prime numbers from 1 to 20
      expect(await instance.getBalance(owner.address)).to.be.eq(8);
    });

    it("Max supply is 20", async () => {
      await expect(token.mint(owner.address)).to.be.revertedWith('Max supply reached already');
    });
});