# What problems ERC777 and ERC1363 solves?

They were both proposed as a way for executing code after an ERC20 transfer/transferFrom. ERC777 had in mind solving the recurring tokens being locked forever problem, while the ERC2363 author had in mind the specific use case of not having to do several transactions when using an ERC20 to pay for something on chain.


# Why was ERC1363 introduced?

ERC1363 was introduced as a solution to the problem with paying on chain with ERC20s, having to make a separate transaction to make a call after transferring the tokens, ERC1363 introduced the `[approve/transfer]AndCall` functions to be able to interact with other contracts after performing the operations inside the ERC20 contract.

# What issues are there with ERC777?

Given the nature of calling external contracts during any execution, the risk of reentrancy is always prevalent, a malicious actor might use the function call to trigger that kind of attack.