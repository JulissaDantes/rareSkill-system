import { expect } from 'chai';
import { ethers } from 'hardhat';
import { Signer, Contract } from 'ethers';

describe('Factory', () => {
  let factory: Contract;
  let tokenA: Contract;
  let tokenB: Contract;
  let owner: Signer;
  let addr1: Signer;

  before(async () => {
    [owner, addr1] = await ethers.getSigners();

    factory = await ethers.deployContract("Factory", [owner.address]);
    tokenA = await ethers.deployContract("MyPairedToken");
    tokenB = await ethers.deployContract("MyPairedToken");

  });

  it('Should deploy the Factory contract', async () => {
    expect(factory.address).to.not.equal(0);
  });

  it('Should create a new pair', async () => {
    const tx = await factory.createPair(tokenB, tokenA);
    await tx.wait();

    const pairAddress = await factory.getPair(tokenB, tokenA);
    expect(pairAddress).to.not.equal(ethers.ZeroAddress);
  });

  it('Should not create an existing pair', async () => {
    await expect(factory.createPair(tokenB, tokenA)).to.be.revertedWith('PAIR_EXISTS');
  });

  it('Should set feeTo', async () => {
    const newFeeTo = await addr1.getAddress();

    await factory.connect(owner).setFeeTo(newFeeTo);
    const feeTo = await factory.feeTo();
    expect(feeTo).to.equal(newFeeTo);
  });

  it('Should set feeToSetter', async () => {
    const newFeeToSetter = await addr1.getAddress();

    await factory.connect(owner).setFeeToSetter(newFeeToSetter);
    const feeToSetter = await factory.feeToSetter();
    expect(feeToSetter).to.equal(newFeeToSetter);
  });
});
