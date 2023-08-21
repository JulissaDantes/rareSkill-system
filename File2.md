# Why does the SafeERC20 program exist and when should it be used?
It exists as a wrapper for ERC20 to make a safe interaction with third party tokens by checking the boolean return values of ERC20 operations and revert the transaction if they fail. 

It should be use when interacting with another token contract to ensure safe operations before changing any state. For example let take a look at this code:
```
    function transfer(address recipient, uint256 amount) external {
        token.transfer(recipient, amount);
        myownTokens -= amount;
    }
```
If a contract is interacting with a token and makes state changes based on the assumption of a successful transfer, and the transfer fails it would be doing an invalid state change. But if instead it uses `safeERC20` the code would look the same but would revert before wrongly changing the state.