pragma solidity ^0.8.11;

import {Contract3, BuyToken} from "../Week1/contract3.sol";

/// @dev Run the template with
///      ```
///      solc-select use 0.8.0
///      echidna contracts/week6/CurveTest.sol --contract TestCurve
///      ```
contract TestCurve is Contract3 {
    address echidna = tx.origin;
    BuyToken _tokenB = new BuyToken("Test", "TS");

    constructor() Contract3(1, 1, address(_tokenB)) {
       
    }

    // Price should never be zero
    function echidna_test_price() public view {
        assert(getPrice(0) > 0);
    }

    // Price should never be zero
    function echidna_test_tokenAmount() public view {
        uint256 amount = getPrice(0);
        (uint256 tokenAmount, uint256 remaining) = getTokenAmount(amount);
        // When sending the price of 1 token amount should be 1 and nothing is leftover
        assert(tokenAmount == 1);
        assert(remaining == 0);

        // when sending more than price but not enough for another there should be a leftover
        uint256 leftover = amount - 1;
        (uint256 tokenAmount2, uint256 remaining2) = getTokenAmount(amount + leftover);
        assert(tokenAmount2 == 1);
        assert(remaining2 == 0);
    }
}
