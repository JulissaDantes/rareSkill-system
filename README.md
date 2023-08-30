# rareSkill-system
I am currently enrolled in RareSkills bootcamp and this repo is for the projects I make while I'm at it.

### Pending:
- [ ] Bonding curve price exponential to initial supply increments
- [ ] use safetoken transfering when working with arbitrary tokens
- [ ]  RareSkills Tutorial on NFTs ([link](https://www.youtube.com/watch?v=dmyADPRG9r4))
- [ ]  NFT Staking using safeTransferFrom and onERC721Received ([link](https://www.youtube.com/watch?v=7wtHR2sZjPw))
- [ ]  ERC721Enumerable Tutorial ([link](http://youtube.com/watch?v=hL5uPgEAuIo))
- [X]  EIP 721 ([link](https://eips.ethereum.org/EIPS/eip-721))
- [X]  Openzeppelin Ownable2Step ([link](https://www.rareskills.io/post/openzeppelin-ownable2step))
- [X]  Study what a merkle tree is and how it works. There are a lot of tutorials for this. Skip if you already know.
- [ ]  Bitmap airdrop and presale ([link](https://medium.com/donkeverse/hardcore-gas-savings-in-nft-minting-part-3-save-30-000-in-presale-gas-c945406e89f0))
- [X]  Read openzeppelin bitmap ([link](https://docs.openzeppelin.com/contracts/4.x/api/utils#BitMaps))
- [X]  Read uniswap merkle distributor ([link](https://github.com/Uniswap/merkle-distributor/blob/master/contracts/MerkleDistributor.sol))
- [ ]  Code to copy for merkle trees ([link](https://github.com/DonkeVerse/PrivateSaleBenchmark/blob/main/contracts/Benchmark.sol))
- [X]  Watch the gas optimization course on Udemy. You should have a free signup link ([link](https://www.udemy.com/course/advanced-solidity-understanding-and-optimizing-gas-costs/))
- [X]  Read ERC2981 NFT Royalties Code ([link](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/common/ERC2981.sol))
- [X]  Read ERC2981 NFT Royalties Spec ([link](https://eips.ethereum.org/EIPS/eip-2981))
- [X]  Read Solidity Events ([link](https://www.rareskills.io/post/ethereum-events))
- [ ]  Read the pre-audit checklist ([link](https://betterprogramming.pub/the-ultimate-100-point-checklist-before-sending-your-smart-contract-for-audit-af9a5b5d95d0))
- [ ]  Read about ERC721A ([link](https://www.azuki.com/erc721a))
- [X]  Read the RareSkills tutorial on Re-entrancy ([link](https://www.rareskills.io/post/where-to-find-solidity-reentrancy-attacks))
- [ ]  Read HypeBears NFT Exploit ([link](https://blocksecteam.medium.com/when-safemint-becomes-unsafe-lessons-from-the-hypebears-security-incident-2965209bda2a))
- [ ]  Read the Wrapped Penguins story ([link](https://www.coindesk.com/business/2022/01/07/pudgy-penguins-nft-project-ousts-founders-as-mood-turns-icy/))
- [ ]  Read the WrappedNFT contract from Openzeppelin ([link](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Wrapper.sol))

- [ ]  Solve solidity riddles Overmint1 ([link](https://github.com/RareSkills/solidity-riddles))
- [ ]  Solve solidity riddles Overmint2 ([link](https://github.com/RareSkills/solidity-riddles))

- [ ]  **Markdown file 1:** Answer these questions
    - [ ]  How does ERC721A save gas?
    - [ ]  Where does it add cost?
    - [ ]  Why shouldn’t ERC721A enumerable’s implementation be used on-chain?
- [ ]  **Markdown file 2:** Besides the examples listed in the code and the reading, what might the wrapped NFT pattern be used for?
- [ ]  **Markdown file 3:** Revisit the solidity events tutorial. How can OpenSea quickly determine which NFTs an address owns if most NFTs don’t use ERC721 enumerable? Explain how you would accomplish this if you were creating an NFT marketplace

- [ ]  **Smart contract ecosystem 1:** Smart contract trio: NFT with merkle tree discount, ERC20 token, staking contract
    - [ ]  Create an ERC721 NFT with a supply of 20.
    - [ ]  Include ERC 2918 royalty in your contract to have a reward rate of 2.5% for any NFT in the collection. Use the openzeppelin implementation.
    - [ ]  Addresses in a merkle tree can mint NFTs at a discount. Use the bitmap methodology described above. Use openzeppelin’s bitmap, don’t implement it yourself.
    - [ ]  Create an ERC20 contract that will be used to reward staking
    - [ ]  Create and a third smart contract that can mint new ERC20 tokens and receive ERC721 tokens. A classic feature of NFTs is being able to receive them to stake tokens. Users can send their NFTs and withdraw 10 ERC20 tokens every 24 hours. Don’t forget about decimal places! The user can withdraw the NFT at any time. The smart contract must take possession of the NFT and only the user should be able to withdraw it. **IMPORTANT**: your staking mechanism must follow the sequence in the video I recorded above (stake NFTs with safetransfer).
    - [ ]  Make the funds from the NFT sale in the contract withdrawable by the owner. Use Ownable2Step.
    - [ ]  **Important:** Use a combination of unit tests and the gas profiler in foundry or hardhat to measure the gas cost of the various operations.

- [ ]  **Smart contract ecosystem 2:** NFT Enumerable Contracts
    - [ ]  Create a new NFT collection with 20 items using ERC721Enumerable. The token ids should be [1..20] inclusive.
    - [ ]  Create a second smart contract that has a function which accepts an address and returns how many NFTs are owned by that address which have tokenIDs that are prime numbers. For example, if an address owns tokenIds 10, 11, 12, 13, it should return 2. In a real blockchain game, these would refer to special items, but we only care about the abstract functionality for this exercise. Don’t hardcode the prime values, this should work for numbers arbitrarily larger than 20. **There is a lot of opportunity to gas optimize this routine**