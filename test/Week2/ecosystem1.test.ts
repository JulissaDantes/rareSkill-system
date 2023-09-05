import { expect } from "chai";
import { ethers } from "hardhat";
import { mine, time } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";

describe("", function () {
    const initialSupply = 100;
    let owner, other;
    let instance: Contract3;
    let tokenA: SellToken;
    let tokenB: BuyToken;
    before(async () => {
      tokenB = await ethers.deployContract("BuyToken", ["BuyToken", "BTK"]);
      instance = await ethers.deployContract("Contract3", [1, 1, tokenB.getAddress()]);
      const TokenAContract = await ethers.getContractFactory("SellToken");
      tokenA = TokenAContract.attach(await instance.getTokenAAddress());
      
      [owner, other] = await ethers.getSigners();

      tokenB.mint(other.address, initialSupply);
    });
  
    it("", async () => {
     
    });
});