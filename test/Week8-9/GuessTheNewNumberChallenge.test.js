const {
    time,
    loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
const { ethers } = require("hardhat");

const NAME = "GuessTheNewNumberChallenge";

describe(NAME, function () {
    async function setup() {
        const initialBalance = ethers.parseEther("1.0");
        const VictimFactory = await ethers.getContractFactory(NAME);
        const victimContract = await VictimFactory.deploy({value: initialBalance});

        return { victimContract };
    }

    describe("exploit", async function () {
        let victimContract;
        before(async function () {
            ({ victimContract } = await loadFixture(setup));
        })

        it("conduct your attack here", async function () {
            const playBalance = ethers.parseEther("1.0");
            const AttackerFactory = await ethers.getContractFactory("GuessTheNewNumberChallengeAttacker");
            const attackerContract = await AttackerFactory.deploy();
            await attackerContract.setVictim(await victimContract.getAddress());
            await attackerContract.attack({value: playBalance});
        });

        after(async function () {
            expect(await victimContract.isComplete()).to.be.true;
        });
    });
});