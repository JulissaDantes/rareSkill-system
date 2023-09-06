# rareSkill-system
I am currently enrolled in RareSkills bootcamp and this repo is for the projects I make while I'm at it.

### Pending:
- [ ] Bonding curve price exponential to initial supply increments
- [ ] use safetoken transfering when working with arbitrary tokens

- [ ] **Markdown file 1:** Answer these questions
    - [ ] How does ERC721A save gas?
    - [ ] Where does it add cost?
    - [ ] Why shouldn’t ERC721A enumerable’s implementation be used on-chain?
- [ ] **Markdown file 2:** Besides the examples listed in the code and the reading, what might the wrapped NFT pattern be used for?

- [ ] **Smart contract ecosystem 2:** NFT Enumerable Contracts
    - [X] Create a new NFT collection with 20 items using ERC721Enumerable. The token ids should be [1..20] inclusive.
    - [X] Create a second smart contract that has a function which accepts an address and returns how many NFTs are owned by that address which have tokenIDs that are prime numbers. For example, if an address owns tokenIds 10, 11, 12, 13, it should return 2. In a real blockchain game, these would refer to special items, but we only care about the abstract functionality for this exercise. Don’t hardcode the prime values, this should work for numbers arbitrarily larger than 20. **There is a lot of opportunity to gas optimize this routine**

- [ ] Make documentation for all files.
- [ ] Add events for ecosystem1
- [ ] Add events tests for ecosystem1
- [ ] Review entire code for gas optimizations and possible attack vectors
- [ ] Check all todos
- [ ] Organize functions by visibility