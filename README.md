# rareSkill-system
I am currently enrolled in RareSkills bootcamp and this repo is for the projects I make while I'm at it.


## Pending
- [X]  **Markdown file 1:** Create a markdown file about what problems ERC777 and ERC1363 solves. Why was ERC1363 introduced, and what issues are there with ERC777?
- [X]  **Markdown file 2:** Why does the SafeERC20 program exist and when should it be used?
- [X]  **Solidity contract 1:** Token with sanctions. Create a fungible token that allows an admin to ban specified addresses from sending and receiving tokens.
- [X]  **Solidity contract 2:** Token with god mode. A special address is able to transfer tokens between addresses at will.
- [ ]  **Solidity contract 3:** (************hard************) Token sale and buyback with bonding curve. The more tokens a user buys, the more expensive the token becomes. To keep things simple, use a linear bonding curve. When a person sends a token to the contract with ERC1363 or ERC777, it should trigger the receive function. If you use a separate contract to handle the reserve and use ERC20, you need to use the approve and send workflow. This should support fractions of tokens.
    - [ ]  Consider the case someone might [sandwhich attack](https://medium.com/coinmonks/defi-sandwich-attack-explain-776f6f43b2fd) a bonding curve. What can you do about it?
    - [ ]  We have intentionally omitted other resources for bonding curves, we encourage you to find them on your own.
- [ ]  **Solidity contract 4: (hard)** Untrusted escrow. Create a contract where a buyer can put an ******************arbitrary****************** ERC20 token into a contract and a seller can withdraw it 3 days later. Based on your readings above, what issues do you need to defend against? Create the safest version of this that you can while guarding against issues that you cannot control.
- [ ] Solidity Natspecs