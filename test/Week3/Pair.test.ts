import { expect } from "chai";
import { ethers } from "hardhat";

describe("Pair", function () {
    let owner, other1, other2;
    let instance: Contract;//factory
    let tokenA: Contract;
    let tokenB: Contract;
    before(async () => {
        [owner, other1, other2] = await ethers.getSigners();
        tokenA = await ethers.deployContract("MyPairedToken");
        tokenB = await ethers.deployContract("MyPairedToken");
        instance = await ethers.deployContract("Factory");
      
    });

    it("Merkle verify works", async () => {

    });
});