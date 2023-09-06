### How does ERC721A save gas?
- Removes updates on owners and token data per token minted, and does it per batch instead.
- Removes redundant storage from tokens own metadata. 

### Where does it add cost?
In the transferFrom and safeTransferFrom functions for tokens minted in larger batches, because when minting the ownership data gets set once per batch, and transferring a tokenID that does not have an explicit owner address set, the contract has to run a loop across all of the tokenIDs until it reaches the first NFT with an explicit owner address to find the owner that has the right to transfer it.

### Why shouldn’t ERC721A enumerable’s implementation be used on-chain?
If someone tries to deploy a ERC721A with the enumerable extension there would be too many storage slots saving redundant data, it wouldnt make sense, they should analyze what do they need from enumerable and just add that to an ERC721A contract.