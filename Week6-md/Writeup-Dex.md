## Dex Ethernaut challenge and Echidna

### Challenge
The goal of this level is for you to hack the basic DEX contract below and steal the funds by price manipulation.

You will start with 10 tokens of token1 and 10 of token2. The DEX contract starts with 100 of each token.

You will be successful in this level if you manage to drain all of at least 1 of the 2 tokens from the contract, and allow the contract to report a "bad" price of the assets.

### What was it testing?
The specific invariant being checked was the instance's token balance. In order to break the CTF we needed to drain the instance of either token, therefore this was the function:
```
    function echidna_test_balance() public returns (bool) {
        address _instance = address(this);

        // To win the CTF I must steal one of the 2 tokens, making the contract hold zero tokens
        return IERC20(token1).balanceOf(_instance) != 0 || ERC20(token2).balanceOf(_instance) != 0;
    }
```

### Echidna results
The tool did not find a path to achieve the condition violation, even after changing the limit.

### How to break the CTF
Due to the formula inside `getSwapPrice` being followed, after each swap the amount fo the other token the user can get out is bigger, therefore if we perform enough swaps I'll be able to steal one of the 2 tokens, due to the price of the tokens incrementing after a couple of swaps the last swap will consist of using the formula to compute how many of token1 or token2 should I send to get all the opposite token remaining inside the contract.

