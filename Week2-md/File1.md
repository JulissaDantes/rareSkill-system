### How does ERC721A save gas?
- Removes updates on owners and token data per token minted, and does it per batch instead.
- Removes redundant storage from tokens own metadata. TODO: say which storage was removed

### Where does it add cost?

### Why shouldn’t ERC721A enumerable’s implementation be used on-chain?
