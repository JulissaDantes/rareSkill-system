// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {IERC1363Receiver} from "erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol";
import {BuyToken} from "./ERC1363.sol";
import {SellToken} from "./ERC20.sol";
import "hardhat/console.sol";

/*
* Token sale and buyback with bonding curve. The more tokens a user buys, the more expensive the token becomes. To keep things simple, use a 
* linear bonding curve. When a person sends a token to the contract with ERC1363 or ERC777, it should trigger the receive function. If you 
* use a separate contract to handle the reserve and use ERC20, you need to use the approve and send workflow. This should support fractions of 
* tokens.
*   - [ ]  Consider the case someone might [sandwhich attack](https://medium.com/coinmonks/defi-sandwich-attack-explain-776f6f43b2fd) a 
*   bonding curve. What can you do about it?
*   - [ ]  We have intentionally omitted other resources for bonding curves, we encourage you to find them on your own.
* IMPORTANT: This contracts locks the ERC1363 tokens used to buy the ERC20, it should have a transfer mechanism to about locking the tokens in,
* but the contract focus only on the token sale using the linear bonding curve to compute the price. I DO NOT RECOMMEND DEPLOYING TO PRODUCTION.
*/
contract Contract3 is IERC1363Receiver, ReentrancyGuard {
    // linear bonding curve growth rate
    uint256 immutable slope;
    // initial token price
    uint256 immutable initialPrice;
    // Token for sale
    SellToken tokenA;
    // Token to buy tokenA with
    BuyToken tokenB;
    // TODO consider using safeToken to interact with the ERC20s
    // TODO add events

    constructor(uint256 _slope, uint256 _initialPrice, address _tokenB) {
        slope = _slope;
        initialPrice = _initialPrice;
        tokenA = new SellToken();
        tokenB = BuyToken(_tokenB);
    }

    function getTokenAAddress() external view returns(address) {
        return address(tokenA);
    }
    
    function sellTokens(uint256 amount) external nonReentrant {
        require(tokenA.balanceOf(msg.sender) >= amount, "Invalid sell amount");
        uint256 price = getPrice();
        uint256 tokenBAmount = price * amount;

        // If not enough players participate in the ecosystem, tokens to be paid might be higher than tokens 
        // available, thefore the selling process has its limits.
        require(tokenBAmount < tokenB.balanceOf(address(this)), "Sell amount is bigger than max sell limit");
        
        tokenB.transfer(msg.sender, tokenBAmount);
        tokenA.burn(msg.sender, amount);
    }

    // buy tokens
    function onTransferReceived(
        address,
        address sender,
        uint256 amount,
        bytes memory
    ) public override returns (bytes4) {
        uint256 price = getPrice();
        uint256 tokenAmount = amount / price;
        require(tokenAmount > 0, "Not enough tokens to buy");
        tokenA.mint(sender, tokenAmount);

        // If payment was not exact returns unused amount
        if (amount != tokenAmount * price) {
            tokenB.transfer(sender, amount-(tokenAmount * price));
        }
        return IERC1363Receiver.onTransferReceived.selector;
    }

    /*
    * Uses linear bonding curve formula to return the price, price = (slope * tokenSupply) + initialPrice.
    * 
    */
    function getPrice() public view returns(uint256) {
        return (slope + tokenA.totalSupply()) + initialPrice;
    }

}
