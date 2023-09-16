import { expect } from "chai";
import { ethers } from "hardhat";

async function addLiquidity(minLiquidity, instance, other1, tokenA, tokenB) {
    const amount = minLiquidity;// so we are not short on liquidity
    const token0Amount = amount;
    const token1Amount = amount;
    await tokenA.mint(token0Amount);
    await tokenB.mint(token1Amount);
    // Mint liquidity tokens

    await tokenA.transfer(await instance.getAddress(), token0Amount);
    await tokenB.transfer(await instance.getAddress(), token1Amount);
    await instance.connect(other1)["mint(address)"](other1.address);

    return [token0Amount, token1Amount];
}

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

        const tokenAddresses = await Promise.all([
            tokenB.getAddress(),
            tokenA.getAddress()
          ]);
          
        [token0, token1] = tokenAddresses.sort();

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
        const [token0Amount, token1Amount] = await addLiquidity(minLiquidity, instance, other1, tokenA, tokenB);
    
        // Check the liquidity balance of other1
        expect(await tokenA.balanceOf(await instance.getAddress())).to.eq(token0Amount);
        expect(await tokenB.balanceOf(await instance.getAddress())).to.eq(token1Amount);
        const reserves = await instance.getReserves();
        expect(reserves[0]).to.eq(token0Amount);
        expect(reserves[1]).to.eq(token1Amount);
    });

    it("should burn liquidity correctly", async function () {
        const prevBalance = await instance.balanceOf(other1.address);
        // Burn liquidity tokens
        await instance.connect(other1).burn(other1.address);
    
        // Check that other1's liquidity balance has decreased
        const updatedLiquidityBalance = await instance.balanceOf(other1.address);
        expect(updatedLiquidityBalance).to.lt(prevBalance);
    });
    
    it.only("should perform swaps correctly", async function () {
      await addLiquidity(minLiquidity, instance, other1, tokenA, tokenB);
      // Initial balances
      const token1Amount = 10;
      await tokenA.connect(other1).mint(token1Amount);        
      const balance0Pair = await tokenA.balanceOf(await instance.getAddress());
      const balance1Pair = await tokenB.balanceOf(await instance.getAddress());        
      const balance0 = await tokenA.balanceOf(other1.address);
      const balance1 = await tokenB.balanceOf(other1.address);
      await tokenA.connect(other1).transfer(await instance.getAddress(), token1Amount);

      // Perform a swap of tokenA for tokenB
      const amount0Out = token1Amount / 2;
      const to = other1.address;
      const data = "0x"; // Empty data for this example
      await instance.connect(other1).swap(0, amount0Out, to, data);

      // Check the updated balances
      const updatedBalance0Pair = await tokenA.balanceOf(await instance.getAddress());
      const updatedBalance1Pair = await tokenB.balanceOf(await instance.getAddress());

      // Contract must have more tokenA and less tokenB
      expect(updatedBalance0Pair).to.be.gt(balance0Pair);
      expect(updatedBalance1Pair).to.be.lt(balance1Pair);

      const updatedBalance0 = await tokenA.balanceOf(other1.address);
      const updatedBalance1 = await tokenB.balanceOf(other1.address);

      // User must have more tokenB and less tokenA
      expect(updatedBalance0).to.be.lt(balance0);
      expect(updatedBalance1).to.be.gt(balance1);
    });

    it("should not allow swaps with insufficient liquidity", async function () {
        // Attempt a swap with insufficient liquidity
        const amount0Out = ethers.parseEther("10000");
        const to = other1.address;
        const data = "0x"; // Empty data for this example
        await expect(
            instance.connect(other1).swap(amount0Out, 0, to, data)
        ).to.be.revertedWith("INSUFFICIENT_LIQUIDITY");
    });

    it("TWAP works as expected", async function () {
        const initialPrice = [];
        const reserves = await instance.getReserves();

        initialPrice.push(await instance.price0CumulativeLast());
        initialPrice.push(await instance.price1CumulativeLast());
        ////////////
        const token1Amount = 10;

        const amount0In = token1Amount/2;
        await tokenA.connect(other1).mint(token1Amount);  
        await tokenA.connect(other1).transfer(await instance.getAddress(), amount0In);
        // swap to a new price eagerly instead of syncing
        const to = other1.address;
        const data = "0x"; // Empty data for this example
        await instance.connect(other1).swap(0, amount0In / 2, to, data);

        const secondPrice = [];
        secondPrice.push(await instance.price0CumulativeLast());
        secondPrice.push(await instance.price1CumulativeLast());

        const timeElapse = BigInt((await ethers.provider.getBlock("latest"))!.timestamp) - reserves[2];
        const expected0Price = initialPrice[0] + ((reserves[1]/reserves[0]) * timeElapse); // reserves[2] = _blockTimestampLast
        const expected1Price = initialPrice[1] + ((reserves[0]/reserves[1]) * timeElapse);

        expect(secondPrice[0]).to.be.eq(expected0Price);
        expect(secondPrice[1]).to.be.eq(expected1Price);
    });

    it("Get Max loan", async function () {
        expect(await instance.maxFlashLoan(await tokenA.getAddress())).to.be.eq(await tokenA.balanceOf(await instance.getAddress()));
        expect(await instance.maxFlashLoan(await tokenB.getAddress())).to.be.eq(await tokenB.balanceOf(await instance.getAddress()));
    });

    it("Gets flash fee", async function () {
        await expect(instance.flashFee(await instance.getAddress(),0)).to.be.revertedWith("Unsupported currency");

        expect(await instance.flashFee(await tokenA.getAddress(), 1000000)).to.be.gt(0);
    });

    it("Performs flash swap", async function () {
        // Deploys borrower
        const receiver = await ethers.deployContract("FlashBorrower", [await instance.getAddress()]);
        // perform flash loan
        await expect(receiver.flashBorrow(await tokenA.getAddress(), 1))
        .to.emit(instance, 'FlashSwap')
        .withArgs(await receiver.getAddress(), await tokenA.getAddress(), 1);
        // check values
    });
});

