pragma solidity ^0.8.0;

import "./token.sol";

/// @dev Run the template with
///      ```
///      solc-select use 0.8.0
///      echidna contracts/week6/testtoken.sol --contract TestToken
///      ```
contract TestToken is Token {
    address echidna = tx.origin;

    constructor() public {
        balances[echidna] = 10000;
    }

    function echidna_test_balance() public view returns (bool) {
        /* first detected:
            Call sequence:
            transfer(0x10000,8999) Time delay: 404997 seconds Block delay: 4023
        */
        return balances[echidna] <= 10000;
    }
}
