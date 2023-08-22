import { expect } from "chai";
import { ethers } from "hardhat";
import { Contract } from "ethers";
import { mine, time } from "@nomicfoundation/hardhat-network-helpers";

describe.only("Contract4", function () {
  const initialSupply = 100;
    let owner, other;
    let instance, token1, token2: Contract;
    before(async () => {
      instance = await ethers.deployContract("Contract4");
      // Re-using token from another scenario
      token1 = await ethers.deployContract("SellToken");
      token2 = await ethers.deployContract("SellToken");

      [owner, other] = await ethers.getSigners();
      
      token1.mint(owner.address, initialSupply);
      token2.mint(owner.address, initialSupply);

      token1.approve(instance.getAddress(), initialSupply);
      token2.approve(instance.getAddress(), initialSupply);
    });
  
    it("Arbitrary ERC20s can be deposited", async () => {
        await instance.deposit(other.address, initialSupply, token1.getAddress());
        await instance.deposit(other.address, initialSupply, token2.getAddress());

        expect(await instance.getTotalFundsByToken(other.address, token1.getAddress())).to.be.eq(initialSupply);
        expect(await instance.getTotalFundsByToken(other.address, token2.getAddress())).to.be.eq(initialSupply);
    });

    it("Withdraw cannot be made before the 3 day period", async () => {
        expect(instance.connect(other).withdraw(token1.getAddress())).to.be.revertedWith('No available funds');
        expect(instance.connect(other).withdraw(token2.getAddress())).to.be.revertedWith('No available funds');
    });

    it("Withdraw can be done after 3 days", async () => {
      // timestamp + 3 days in seconds
      const newTimestamp = (await ethers.provider.getBlock("latest"))!.timestamp + (3 * 24 * 60 * 60);
      await time.increaseTo(newTimestamp);
      await mine();

      await instance.connect(other).withdraw(token1.getAddress());
      expect(await token1.balanceOf(other.address)).to.be.eq(initialSupply);
    });

    it("Cannot withdraw already withdrawn amount", async () => {
        
    });
  });