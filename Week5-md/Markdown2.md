## Vertigo rs
### Mutations discovered
All mutations from all contracts can be seen inside the `my_file` file. But, the mutations belonging to the ERC20 and ERC721 staking system, had 15 Killed test, meaning that after the following mutations the test dint break:
1. 
```
    File: /Users/julissadantes-castillo/Documents/rareSkill-system/src/Week2/Ecosystem1/ERC20.sol
    Line nr: 11
    Result: Killed
    Original line:
                 _mint(to, amount);

    Mutated line:
   
```
2. 
```
Mutation: VALID
    File: /Users/julissadantes-castillo/Documents/rareSkill-system/src/Week2/Ecosystem1/NFT.sol
    Line nr: 38
    Result: Killed
    Original line:
                 require(totalSupply < MAX_SUPPLY, "Max supply reached already");

    Mutated line:
                 require(totalSupply <= MAX_SUPPLY, "Max supply reached already");

```
3. 
```
Mutation: VALID
    File: /Users/julissadantes-castillo/Documents/rareSkill-system/src/Week2/Ecosystem1/NFT.sol
    Line nr: 38
    Result: Killed
    Original line:
                 require(totalSupply < MAX_SUPPLY, "Max supply reached already");

    Mutated line:
                 require(totalSupply >= MAX_SUPPLY, "Max supply reached already");

```
4. 
```
Mutation: VALID
    File: /Users/julissadantes-castillo/Documents/rareSkill-system/src/Week2/Ecosystem1/NFT.sol
    Line nr: 49
    Result: Killed
    Original line:
                 require(discount ? msg.value >= price / 2 : msg.value >= price, "Invalid amount sent");

    Mutated line:
                 require(discount ? msg.value >= price / 2 : msg.value < price, "Invalid amount sent");
```
5. 
```
Mutation: VALID
    File: /Users/julissadantes-castillo/Documents/rareSkill-system/src/Week2/Ecosystem1/NFT.sol
    Line nr: 49
    Result: Killed
    Original line:
                 require(discount ? msg.value >= price / 2 : msg.value >= price, "Invalid amount sent");

    Mutated line:
                 require(discount ? msg.value < price / 2 : msg.value >= price, "Invalid amount sent");

```
6. 
```
Mutation: VALID
    File: /Users/julissadantes-castillo/Documents/rareSkill-system/src/Week2/Ecosystem1/NFT.sol
    Line nr: 49
    Result: Killed
    Original line:
                 require(discount ? msg.value >= price / 2 : msg.value >= price, "Invalid amount sent");

    Mutated line:
                 require(discount ? msg.value >= price * 2 : msg.value >= price, "Invalid amount sent");
```
7. 
```
Mutation: VALID
    File: /Users/julissadantes-castillo/Documents/rareSkill-system/src/Week2/Ecosystem1/NFT.sol
    Line nr: 22
    Result: Killed
    Original line:
                 _setDefaultRoyalty(receiver, 25);

    Mutated line:
```
8. 
```
Mutation: VALID
    File: /Users/julissadantes-castillo/Documents/rareSkill-system/src/Week2/Ecosystem1/NFT.sol
    Line nr: 53
    Result: Killed
    Original line:
                 _mint(to, tokenId);

    Mutated line:
                 

```
9. 
```
Mutation: VALID
    File: /Users/julissadantes-castillo/Documents/rareSkill-system/src/Week2/Ecosystem1/StakeNFT.sol
    Line nr: 35
    Result: Killed
    Original line:
                 require(lastWithdraw[msg.sender] + withdrawalInterval <= block.timestamp, "Wait 24 hours");

    Mutated line:
                 require(lastWithdraw[msg.sender] + withdrawalInterval < block.timestamp, "Wait 24 hours");
```
10. 
```
Mutation: VALID
    File: /Users/julissadantes-castillo/Documents/rareSkill-system/src/Week2/Ecosystem1/StakeNFT.sol
    Line nr: 43
    Result: Killed
    Original line:
                 require(msg.sender == originalOwner[tokenId], "Not the original owner");

    Mutated line:
                 require(msg.sender != originalOwner[tokenId], "Not the original owner");
``` 
11. 
```
Mutation: VALID
    File: /Users/julissadantes-castillo/Documents/rareSkill-system/src/Week2/Ecosystem1/StakeNFT.sol
    Line nr: 53
    Result: Killed
    Original line:
                 require(msg.sender == address(nft), "Invalid NFT address");

    Mutated line:
                 require(msg.sender != address(nft), "Invalid NFT address");
``` 
12. 
```
Mutation: VALID
    File: /Users/julissadantes-castillo/Documents/rareSkill-system/src/Week2/Ecosystem1/StakeNFT.sol
    Line nr: 35
    Result: Killed
    Original line:
                 require(lastWithdraw[msg.sender] + withdrawalInterval <= block.timestamp, "Wait 24 hours");

    Mutated line:
                 require(lastWithdraw[msg.sender] + withdrawalInterval > block.timestamp, "Wait 24 hours");
``` 
13. 
```
Mutation: VALID
    File: /Users/julissadantes-castillo/Documents/rareSkill-system/src/Week2/Ecosystem1/StakeNFT.sol
    Line nr: 43
    Result: Killed
    Original line:
                 require(msg.sender == originalOwner[tokenId], "Not the original owner");

    Mutated line:
                 require(msg.sender != originalOwner[tokenId], "Not the original owner");
``` 
14. 
```
Mutation: VALID
    File: /Users/julissadantes-castillo/Documents/rareSkill-system/src/Week2/Ecosystem1/StakeNFT.sol
    Line nr: 53
    Result: Killed
    Original line:
                 require(msg.sender == address(nft), "Invalid NFT address");

    Mutated line:
                 require(msg.sender != address(nft), "Invalid NFT address");
``` 
15. 
```
Mutation: VALID
    File: /Users/julissadantes-castillo/Documents/rareSkill-system/src/Week2/Ecosystem1/StakeNFT.sol
    Line nr: 35
    Result: Killed
    Original line:
                 require(lastWithdraw[msg.sender] + withdrawalInterval <= block.timestamp, "Wait 24 hours");

    Mutated line:
                 require(lastWithdraw[msg.sender] - withdrawalInterval <= block.timestamp, "Wait 24 hours");
```