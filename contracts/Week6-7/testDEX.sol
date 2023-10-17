//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./DEXCTF.sol";

/// @dev Run the template with
///      ```
///      solc-select use 0.8.0
///      echidna contracts/week6/testDEX.sol --contract TestDEX
///      ```
contract TestDEX is Dex {
    address echidna = tx.origin;
    event LogValues(uint256 value, uint256 value2);

    constructor() public {
        //set conditions the level factory sets
        SwappableToken tokenInstance = new SwappableToken(address(this), "Token 1", "TKN1", 110);
        SwappableToken tokenInstanceTwo = new SwappableToken(address(this), "Token 2", "TKN2", 110);

        address tokenInstanceAddress = address(tokenInstance);
        address tokenInstanceTwoAddress = address(tokenInstanceTwo);

        setTokens(tokenInstanceAddress, tokenInstanceTwoAddress);

        tokenInstance.approve(address(this), 100);
        tokenInstanceTwo.approve(address(this), 100);
        // The next section is not needed because this is not a factory contract but the contract itself
        // addLiquidity(tokenInstanceAddress, 100);
        // addLiquidity(tokenInstanceTwoAddress, 100);

        tokenInstance.transfer(echidna, 10);
        tokenInstanceTwo.transfer(echidna, 10);

        // This part happens so echidna is not the owner for the tests:
        renounceOwnership();
    }

    function echidna_test_balance() public returns (bool) {
        address _instance = address(this);
        // should check that both tokens balances are 0
        emit LogValues(IERC20(token1).balanceOf(_instance), IERC20(token2).balanceOf(_instance));
        // To win the CTF I must steal one of the 2 tokens, making the contract hold zero tokens
        return IERC20(token1).balanceOf(_instance) != 0 || ERC20(token2).balanceOf(_instance) != 0;
    }
    // NOTE: after 9000000 runs it would not find a path where I drain the contract from one of the tokens
    // A personally found path can be found inside the Exploit contract
}
