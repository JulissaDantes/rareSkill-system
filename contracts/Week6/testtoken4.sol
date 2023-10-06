pragma solidity ^0.8.0;

import "./token4.sol";

/// @dev Run the template with
///      ```
///      solc-select use 0.8.0
///      echidna contracts/week6/testtoken4.sol --contract TestToken --test-mode assertion
///      ```
contract TestToken is Token {
    function transfer(address to, uint256 value) public override {
        uint256 senderInitialBalance = balances[msg.sender];
        uint256 toInitialBalance = balances[to];
        super.transfer(to, value);
        assert(balances[msg.sender] <= senderInitialBalance);
        assert(balances[to] >= toInitialBalance);
    }

    /*
    This did not exploded evn after increasing test limit: resume():  passed! 🎉
    balances(address):  passed! 🎉
    paused():  passed! 🎉
    pause():  passed! 🎉
    owner():  passed! 🎉
    transfer(address,uint256):  passed! 🎉
    transferOwnership(address):  passed! 🎉
    AssertionFailed(..):  passed! 🎉
    Unique instructions: 1092
    Unique codehashes: 1
    Corpus size: 7
    Seed: 1866928978287023232
     */
}
