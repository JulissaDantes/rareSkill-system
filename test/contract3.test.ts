import { expect } from "chai";
import { ethers } from "hardhat";
import { Contract } from "ethers";

describe.only("Contract3", function () {
    const initialSupply = 100;
    let owner, other;
    let instance: Contract;
    let tokenA: Contract;
    let tokenB: Contract;
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
      await tokenB.connect(other).transferAndCall(await instance.getAddress(), initialSupply);

      expect(balanceBefore).to.be.lt(await tokenA.balanceOf(other.address));
      expect(priceBefore).to.be.lt(await instance.getPrice());
    });

    it("Account can sell token and price decreases after sell", async () => {
      const priceBefore = await instance.getPrice();
      const balanceBefore = await tokenA.balanceOf(other.address);

      await instance.connect(other).sellTokens(1);

      expect(balanceBefore).to.be.gt(await tokenA.balanceOf(other.address));
      expect(priceBefore).to.be.gt(await instance.getPrice());
    });
    //TODO test for reverts and negative scenarios
  });