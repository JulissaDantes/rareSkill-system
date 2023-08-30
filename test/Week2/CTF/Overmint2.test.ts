
import { expect } from "chai";
import { ethers } from "hardhat";


describe("Overmint2", function () {
    async function setup() {
        const [owner, attackerWallet] = await ethers.getSigners();

        const VictimFactory = await ethers.getContractFactory("Overmint2");
        const victimContract = await VictimFactory.deploy();

        return { victimContract, attackerWallet };
    }

    describe("exploit", async function () {
        let victimContract, attackerWallet;
        before(async function () {
            ({ victimContract, attackerWallet } = await loadFixture(setup));
        })

        it("conduct your attack here", async function () {
            const AttackerFactory = await ethers.getContractFactory("Overmint2Attacker");
            const attackerContract = await AttackerFactory.connect(attackerWallet).deploy(victimContract.address);
        });

        after(async function () {
            expect(await victimContract.balanceOf(attackerWallet.address)).to.be.equal(5);
            expect(await ethers.provider.getTransactionCount(attackerWallet.address)).to.equal(1, "must exploit one transaction");
        });
    });
});