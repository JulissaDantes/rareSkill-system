pragma solidity ^0.8.0;

import "./mintable.sol";

/// @dev Run the template with
///      ```
///      solc-select use 0.8.0
///      echidna contracts/week6/testtoken3.sol --contract TestToken
///      ```
contract TestToken is MintableToken {
    address echidna = msg.sender;

    // TODO: update the constructor
    constructor() public MintableToken(10_000) {
        owner = echidna;
    }

    function echidna_test_balance() public view returns (bool) {
        /* Initial error:
            echidna_test_balance: failed!💥  
            Call sequence:
            mint(113720458667413355553772403741011237914059088713786126121688449894901720218177) Time delay: 361136 seconds Block delay: 53451
            transfer(0x10000,98127509648250247642299129383287900870054035130676978616257306703122485509315) Time delay: 150273 seconds Block delay: 21726
        */
        return balances[msg.sender] <= 10_000;
    }
}