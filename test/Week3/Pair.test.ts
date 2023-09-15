import { expect } from "chai";
import { ethers } from "hardhat";

describe.only("Pair", function () {
    let owner, other1, other2;
    let instance: Contract, factory;
    let tokenA: Contract;
    let tokenB: Contract;
    let token0, token1;
    let minLiquidity = 10 ** 3;
    before(async () => {
        [owner, other1, other2] = await ethers.getSigners();
        tokenA = await ethers.deployContract("MyPairedToken");
        tokenB = await ethers.deployContract("MyPairedToken");
        factory = await ethers.deployContract("Factory", [owner.address]);
        // TODO make next line cleaner
        [token0 , token1] = (await tokenB.getAddress() < await tokenA.getAddress())? [await tokenB.getAddress(), await tokenA.getAddress()]: [await tokenA.getAddress(), await tokenB.getAddress()];
        await factory.createPair(token0, token1);
        const pairAddress = await factory.getPair(token0, token1);
        const PairContract = await ethers.getContractFactory("Pair");
        instance = PairContract.attach(pairAddress);
    });

    it("should initialize with the correct values", async function () {
        expect(await instance.factory()).to.equal(await factory.getAddress());
        expect(await instance.token0()).to.equal(token0);
        expect(await instance.token1()).to.equal(token1);
      });


    it("should mint liquidity correctly", async function () {
        const amount = minLiquidity * 4;// so we are not short on liquidity
        await tokenA.mint(amount);
        await tokenB.mint(amount);
        // Mint liquidity tokens
        const token0Amount = amount / 4;
        const token1Amount = amount;
  
        await tokenA.transfer(await instance.getAddress(), token0Amount);
        await tokenB.transfer(await instance.getAddress(), token1Amount);

        await instance.connect(other1)["mint(address)"](other1.address);
    
        // Check the liquidity balance of other1
        expect(await tokenA.balanceOf(await instance.getAddress())).to.eq(token0Amount);
        expect(await tokenB.balanceOf(await instance.getAddress())).to.eq(token1Amount);
        const reserves = await instance.getReserves();
        expect(reserves[0]).to.eq(token0Amount);
        expect(reserves[1]).to.eq(token1Amount);
    });

    it("should burn liquidity correctly", async function () {
        // Burn liquidity tokens
        await instance.connect(other1).burn(other1.address);
    
        // Check that other1's liquidity balance has decreased
        const updatedLiquidityBalance = await instance.balanceOf(other1.address);
        expect(updatedLiquidityBalance).to.equal(minLiquidity);
    });
    
      it("should perform swaps correctly", async function () {
        // Initial balances
        const initialBalance0 = ethers.utils.parseEther("1000");
        const initialBalance1 = ethers.utils.parseEther("2000");
        await tokenA.transfer( await instance.getAddress(), initialBalance0);
        await tokenB.transfer( await instance.getAddress(), initialBalance1);
    
        // Perform a swap
        const amount0Out = ethers.utils.parseEther("10");
        const to = other1.address;
        const data = "0x"; // Empty data for this example
        await instance.connect(other1).swap(amount0Out, 0, to, data);
    
        // Check the updated balances
        const updatedBalance0 = await tokenA.balanceOf( await instance.getAddress());
        const updatedBalance1 = await tokenB.balanceOf( await instance.getAddress());
        expect(updatedBalance0).to.equal(initialBalance0.sub(amount0Out));
        // Ensure balance1 increased by an appropriate amount based on the swap
        expect(updatedBalance1).to.be.above(initialBalance1);
      });
    
    /* it("should not allow swaps with insufficient liquidity", async function () {
        // Attempt a swap with insufficient liquidity
        const amount0Out = ethers.utils.parseEther("10000");
        const to = other1.address;
        const data = "0x"; // Empty data for this example
        await expect(
            instance.connect(other1).swap(amount0Out, 0, to, data)
        ).to.be.revertedWith("INSUFFICIENT_LIQUIDITY");
      });*/
});

