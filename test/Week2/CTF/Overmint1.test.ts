import { expect } from "chai";
import { ethers } from "hardhat";
import { loadFixture, time } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";

describe.only("Overmint1", function () {
    async function setup() {
        const [owner, attackerWallet] = await ethers.getSigners();

        const VictimFactory = await ethers.getContractFactory("Overmint1");
        const victimContract = await VictimFactory.deploy();

        return { victimContract, attackerWallet };
    }

    describe("exploit", async function () {
        let victimContract, attackerWallet, attackerContract;
        before(async function () {
            ({ victimContract, attackerWallet } = await loadFixture(setup));
        })

        it("conduct your attack here", async function () {
            const AttackerFactory = await ethers.getContractFactory("Overmint1Attacker");
            attackerContract = await AttackerFactory.connect(attackerWallet).deploy(await victimContract.getAddress());
            await attackerContract.connect(attackerWallet).attack();
        });

        after(async function () {
            expect(await victimContract.balanceOf(await attackerContract.getAddress())).to.be.equal(5);
            expect(await ethers.provider.getTransactionCount(attackerWallet.address)).to.lessThan(3, "must exploit in two transactions or less");
        });
    });
});