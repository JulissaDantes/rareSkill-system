// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/*
* Token sale and buyback with bonding curve. The more tokens a user buys, the more expensive the token becomes. To keep things simple, use a 
* linear bonding curve. When a person sends a token to the contract with ERC1363 or ERC777, it should trigger the receive function. If you 
* use a separate contract to handle the reserve and use ERC20, you need to use the approve and send workflow. This should support fractions of 
* tokens.
*   - [ ]  Consider the case someone might [sandwhich attack](https://medium.com/coinmonks/defi-sandwich-attack-explain-776f6f43b2fd) a 
*   bonding curve. What can you do about it?
*   - [ ]  We have intentionally omitted other resources for bonding curves, we encourage you to find them on your own.
*/
contract Contract3 {
    // linear bonding curve growth rate
    uint256 immutable slope;
    // initial token price
    uint256 immutable initialPrice;
    // Token for sale
    ERC20 tokenA;
    // Token to buy tokenA with
    ERC20 tokenB;
    // TODO consider using safeToken to interact with the ERC20s

    constructor(uint256 _slope, uint256 _initialPrice, address _tokenA, address _tokenB) {
        slope = _slope;
        initialPrice = _initialPrice;
        tokenA = ERC20(_tokenA);//TODO maybe this should hold all the reserve and deploy an ERC20 
                                // during runtime, but I dont think thats a good design
        tokenB = ERC20(_tokenB);
    }
    // TODO the receive function to be triggered on transfer

    function buyTokens(uint256 amount) external {
        uint256 price = getPrice();
        //mint token A to the buyer
        // compute the amount of tokens the buyer can purchase based on the price and the amount they sent
    }

    function sellTokens(uint256 amount) external {
        uint256 price = getPrice();
        // burn tokenA from the seller
        // compute the amount of tokens the seller can sell based on the price and the amount they sent
    }

    /*
    * Uses linear bonding curve formula to return the price, price = (slope * tokenSupply) + initialPrice.
    * 
    */
    function getPrice() internal view returns(uint256) {
        return (slope + tokenA.totalSupply()) + initialPrice;
    }
}
