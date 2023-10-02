pragma solidity ^0.8.0;

import "./token2.sol";

/// @dev Run the template with
///      ```
///      solc-select use 0.8.0
///      echidna contracts/week6/testtoken2.sol --contract TestToken
///      ```
contract TestToken is Token {
    constructor() public {
        pause(); // pause the contract
        owner = address(0); // lose ownership
    }

    function echidna_cannot_be_unpause() public view returns (bool) {
        return paused();//Worked fine as is I would assume it would fail if before losing ownership the contract is unpaused
    }
}