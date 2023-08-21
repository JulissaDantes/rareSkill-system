import { expect } from "chai";
import { ethers } from "hardhat";
import { Contract } from "ethers";

describe("Contract3", function () {
    let owner, other;
    let instance: Contract;
    before(async () => {
      instance = await ethers.deployContract("Contract3");

      [owner, other] = await ethers.getSigners();
  
    });
  
    it("Un-banned account can handle tokens", async () => {
        
    });

    it("Banned account cannot handle tokens", async () => {
        
    });
  });