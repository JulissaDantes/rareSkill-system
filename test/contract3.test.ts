import { expect } from "chai";
import { ethers } from "hardhat";
import { Contract3, SellToken, BuyToken } from "../typechain-types";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";

describe("Contract3", function () {
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
  
    it("Account can buy token by sending tokens to contract and price increases after buy", async () => {
      const priceBefore = await instance.getPrice();
      const balanceBefore = await tokenA.balanceOf(other.address);

      await expect(tokenB.connect(other).transferAndCall(await instance.getAddress(), initialSupply))
        .to.emit(instance, 'BuyTokens')
        .withArgs(other.address, anyValue, priceBefore);

      expect(balanceBefore).to.be.lt(await tokenA.balanceOf(other.address));
      expect(priceBefore).to.be.lt(await instance.getPrice());
    });

    it("Account can sell token and price decreases after sell", async () => {
      const priceBefore = await instance.getPrice();
      const balanceBefore = await tokenA.balanceOf(other.address);

      await expect(instance.connect(other).sellTokens(1))
        .to.emit(instance, 'SellTokens')
        .withArgs(other.address, anyValue, priceBefore);

      expect(balanceBefore).to.be.gt(await tokenA.balanceOf(other.address));
      expect(priceBefore).to.be.gt(await instance.getPrice());
    });
    //TODO test for reverts and negative scenarios
  });