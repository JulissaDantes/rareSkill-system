import { expect } from "chai";
import { ethers } from "hardhat";
import { Contract3, SellToken, BuyToken } from "../typechain-types";
import { mine, time } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";

async function mineCoolDown() {
  const dayInSeconds = 24 * 60 * 60;
  await time.increaseTo((await ethers.provider.getBlock("latest"))!.timestamp + dayInSeconds);
  await mine();
}

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
      const priceBefore = await instance.getPrice(0);
      const balanceBefore = await tokenA.balanceOf(other.address);

      await expect(tokenB.connect(other).transferAndCall(await instance.getAddress(), initialSupply))
        .to.emit(instance, 'BuyTokens')
        .withArgs(other.address, anyValue, anyValue);

      expect(balanceBefore).to.be.lt(await tokenA.balanceOf(other.address));
      expect(priceBefore).to.be.lt(await instance.getPrice(0));
    });

    it("Account cannot call directly to buy tokens", async () => {
      await expect(instance.connect(other).onTransferReceived(owner.address, other.address, initialSupply, "0x")).to.be.revertedWith('Only transfers can trigger this function');
    });

    it("Account can sell token and price decreases after sell", async () => {
      const priceBefore = await instance.getPrice(0);
      const balanceBefore = await tokenA.balanceOf(other.address);

      await expect(instance.connect(other).sellTokens(1))
        .to.emit(instance, 'SellTokens')
        .withArgs(other.address, anyValue, priceBefore);

      expect(balanceBefore).to.be.gt(await tokenA.balanceOf(other.address));
      expect(priceBefore).to.be.gt(await instance.getPrice(0));
    });
    
    it("Account need to wait for cooldown period", async () => {
      const balanceB = await tokenB.balanceOf(other);
      const balanceBefore = await tokenA.balanceOf(other.address);
  
      await expect(tokenB.connect(other).transferAndCall(await instance.getAddress(), balanceB)).to.be.revertedWith('Please wait until the cooldown period expires');

      await mineCoolDown();

      await tokenB.connect(other).transferAndCall(await instance.getAddress(), balanceB);

      expect(balanceBefore).to.be.lt(await tokenA.balanceOf(other.address));
    });

    it("Transaction reverts if minimum to buy is less than 1", async () => {
      await mineCoolDown();
      tokenB.mint(other.address, initialSupply);
      const price = await instance.getPrice(0);
      const amountToBuy = price - BigInt(1);
      
      await expect(tokenB.connect(other).transferAndCall(await instance.getAddress(), amountToBuy)).to.be.revertedWith('Not enough tokens to buy');
    });

    it("Token B is returned if not used", async () => {
      const price = await instance.getPrice(0);
      const amountToBuy = price + (price/BigInt(2));// 1.5 price, not enough for 2 tokens
      const tokenAmount = amountToBuy / price;
      const prevABalance = await tokenA.balanceOf(other.address);
      const prevBBalance = await tokenB.balanceOf(other.address);

      await expect(tokenB.connect(other).transferAndCall(await instance.getAddress(), amountToBuy))
        .to.emit(instance, 'BuyTokens')
        .withArgs(other.address, tokenAmount, anyValue);
      
      expect(await tokenA.balanceOf(other.address)).to.be.eq(prevABalance + tokenAmount);
      expect(await tokenB.balanceOf(other.address)).to.be.eq(prevBBalance - (tokenAmount * price));
    });
  });