const {
    time,
    loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");

const NAME = "PredictTheFutureChallenge";

describe(NAME, function () {
    async function setup() {
        const playBalance = ethers.parseEther("1.0");
        const VictimFactory = await ethers.getContractFactory(NAME);
        const victimContract = await VictimFactory.deploy({value: playBalance});

        return { victimContract, playBalance };
    }

    describe("exploit", async function () {
        let victimContract, playBalance;
        before(async function () {
            ({ victimContract, playBalance } = await loadFixture(setup));
        })

        it("conduct your attack here", async function () {
            const AttackerFactory = await ethers.getContractFactory("PredictTheFutureChallengeAttacker");
            const attackerContract = await AttackerFactory.deploy(await victimContract.getAddress());
            await attackerContract.lockInGuess({value: playBalance});
            while(!(await victimContract.isComplete())) {
                console.log("estamos viendo");
                await attackerContract.attack();
            }

        });

        after(async function () {
            expect(await victimContract.isComplete()).to.be.true;
        });
    });
});