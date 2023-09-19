## Slither

The following are the slither results. If the line starts with a TRUE it means that slither recognized a real problem/warning, and if the line starts with FALSE it means that given the context is not a valid problem/warning report:


FALSE Pair.flashLoan(IERC3156FlashBorrower,address,uint256,bytes) (contracts/Week3-4/Pair.sol#66-96) uses arbitrary from in transferFrom: require(bool,string)(IERC20(tokenIn).transferFrom(address(receiver),address(this),AmountIn),Repay failed) (contracts/Week3-4/Pair.sol#89)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#arbitrary-from-in-transferfrom

FALSE Pair._update(uint256,uint256,uint112,uint112) (contracts/Week3-4/Pair.sol#113-152) uses a weak PRNG: "blockTimestamp = uint32(block.timestamp % 2 ** 32) (contracts/Week3-4/Pair.sol#115)" 
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#weak-PRNG

FALSE Contract3.onTransferReceived(address,address,uint256,bytes) (contracts/Week1/contract3.sol#71-92) performs a multiplication on the result of a division:
        - tokenAmount = amount / price (contracts/Week1/contract3.sol#80)
        - amount != tokenAmount * price (contracts/Week1/contract3.sol#85)
FALSE Contract3.onTransferReceived(address,address,uint256,bytes) (contracts/Week1/contract3.sol#71-92) performs a multiplication on the result of a division:
        - tokenAmount = amount / price (contracts/Week1/contract3.sol#80)
        - require(bool,string)(tokenB.transfer(sender,amount - (tokenAmount * price)),Transfer failed) (contracts/Week1/contract3.sol#86)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#divide-before-multiply

FALSE Pair.mint(address) (contracts/Week3-4/Pair.sol#155-177) uses a dangerous strict equality:
        - _totalSupply == 0 (contracts/Week3-4/Pair.sol#165)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#dangerous-strict-equalities

TRUE Contract locking ether found:
        Contract MyEnumerableToken (contracts/Week2/Ecosystem2/ERC721.sol#7-31) has payable functions:
         - MyEnumerableToken.mint(address) (contracts/Week2/Ecosystem2/ERC721.sol#12-15)
        But does not have a function to withdraw the ether
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#contracts-that-lock-ether

FALSE Reentrancy in Pair.burn(address) (contracts/Week3-4/Pair.sol#181-202):
        External calls:
        - IERC20(_token0).safeTransfer(to,amount0) (contracts/Week3-4/Pair.sol#195)
        - IERC20(_token1).safeTransfer(to,amount1) (contracts/Week3-4/Pair.sol#196)
        State variables written after the call(s):
        - _update(balance0,balance1,_reserve0,_reserve1) (contracts/Week3-4/Pair.sol#200)
                - blockTimestampLast = blockTimestamp (contracts/Week3-4/Pair.sol#150)
        Pair.blockTimestampLast (contracts/Week3-4/Pair.sol#31) can be used in cross function reentrancies:
        - Pair._update(uint256,uint256,uint112,uint112) (contracts/Week3-4/Pair.sol#113-152)
        - Pair.getReserves() (contracts/Week3-4/Pair.sol#252-256)
        - kLast = uint256(reserve0) * reserve1 (contracts/Week3-4/Pair.sol#201)
        Pair.kLast (contracts/Week3-4/Pair.sol#35) can be used in cross function reentrancies:
        - Pair.kLast (contracts/Week3-4/Pair.sol#35)
        - _update(balance0,balance1,_reserve0,_reserve1) (contracts/Week3-4/Pair.sol#200)
                - reserve0 = uint112(balance0) (contracts/Week3-4/Pair.sol#148)
        Pair.reserve0 (contracts/Week3-4/Pair.sol#29) can be used in cross function reentrancies:
        - Pair._update(uint256,uint256,uint112,uint112) (contracts/Week3-4/Pair.sol#113-152)
        - Pair.getReserves() (contracts/Week3-4/Pair.sol#252-256)
        - Pair.sync() (contracts/Week3-4/Pair.sol#259-261)
        - _update(balance0,balance1,_reserve0,_reserve1) (contracts/Week3-4/Pair.sol#200)
                - reserve1 = uint112(balance1) (contracts/Week3-4/Pair.sol#149)
        Pair.reserve1 (contracts/Week3-4/Pair.sol#30) can be used in cross function reentrancies:
        - Pair._update(uint256,uint256,uint112,uint112) (contracts/Week3-4/Pair.sol#113-152)
        - Pair.getReserves() (contracts/Week3-4/Pair.sol#252-256)
        - Pair.sync() (contracts/Week3-4/Pair.sol#259-261)
FALSE Reentrancy in Factory.createPair(address,address) (contracts/Week3-4/Factory.sol#23-37):
        External calls:
        - IPair(pair).initialize(tokenA,tokenB) (contracts/Week3-4/Factory.sol#33)
        State variables written after the call(s):
        - getPair[tokenA][tokenB] = pair (contracts/Week3-4/Factory.sol#34)
        Factory.getPair (contracts/Week3-4/Factory.sol#14) can be used in cross function reentrancies:
        - Factory.createPair(address,address) (contracts/Week3-4/Factory.sol#23-37)
        - Factory.getPair (contracts/Week3-4/Factory.sol#14)
TRUE Reentrancy in Pair.flashLoan(IERC3156FlashBorrower,address,uint256,bytes) (contracts/Week3-4/Pair.sol#66-96):
        External calls:
        - IERC20(tokenOut).safeTransfer(address(receiver),amount) (contracts/Week3-4/Pair.sol#77)
        - require(bool,string)(receiver.onFlashLoan(msg.sender,token,amount,AmountIn,data) == keccak256(bytes)(ERC3156FlashBorrower.onFlashLoan),IERC3156: Callback failed) (contracts/Week3-4/Pair.sol#80-84)
        - require(bool,string)(IERC20(tokenIn).transferFrom(address(receiver),address(this),AmountIn),Repay failed) (contracts/Week3-4/Pair.sol#89)
        State variables written after the call(s):
        - sync() (contracts/Week3-4/Pair.sol#92)
                - blockTimestampLast = blockTimestamp (contracts/Week3-4/Pair.sol#150)
        Pair.blockTimestampLast (contracts/Week3-4/Pair.sol#31) can be used in cross function reentrancies:
        - Pair._update(uint256,uint256,uint112,uint112) (contracts/Week3-4/Pair.sol#113-152)
        - Pair.getReserves() (contracts/Week3-4/Pair.sol#252-256)
        - sync() (contracts/Week3-4/Pair.sol#92)
                - reserve0 = uint112(balance0) (contracts/Week3-4/Pair.sol#148)
        Pair.reserve0 (contracts/Week3-4/Pair.sol#29) can be used in cross function reentrancies:
        - Pair._update(uint256,uint256,uint112,uint112) (contracts/Week3-4/Pair.sol#113-152)
        - Pair.getReserves() (contracts/Week3-4/Pair.sol#252-256)
        - Pair.sync() (contracts/Week3-4/Pair.sol#259-261)
        - sync() (contracts/Week3-4/Pair.sol#92)
                - reserve1 = uint112(balance1) (contracts/Week3-4/Pair.sol#149)
        Pair.reserve1 (contracts/Week3-4/Pair.sol#30) can be used in cross function reentrancies:
        - Pair._update(uint256,uint256,uint112,uint112) (contracts/Week3-4/Pair.sol#113-152)
        - Pair.getReserves() (contracts/Week3-4/Pair.sol#252-256)
        - Pair.sync() (contracts/Week3-4/Pair.sol#259-261)
FALSE Reentrancy in Contract3.onTransferReceived(address,address,uint256,bytes) (contracts/Week1/contract3.sol#71-92):
        External calls:
        - tokenA.mint(sender,tokenAmount) (contracts/Week1/contract3.sol#82)
        - require(bool,string)(tokenB.transfer(sender,amount - (tokenAmount * price)),Transfer failed) (contracts/Week1/contract3.sol#86)
        State variables written after the call(s):
        - _cooldownAccounts[msg.sender] = uint32(block.timestamp + COOLDOWN_TIME) (contracts/Week1/contract3.sol#89)
        Contract3._cooldownAccounts (contracts/Week1/contract3.sol#32) can be used in cross function reentrancies:
        - Contract3.onTransferReceived(address,address,uint256,bytes) (contracts/Week1/contract3.sol#71-92)
FALSE Reentrancy in Contract3.sellTokens(uint256) (contracts/Week1/contract3.sol#50-67):
        External calls:
        - require(bool,string)(tokenB.transfer(msg.sender,tokenBAmount),Transfer failed) (contracts/Week1/contract3.sol#63)
        - tokenA.burn(msg.sender,amount) (contracts/Week1/contract3.sol#64)
        State variables written after the call(s):
        - _cooldownAccounts[msg.sender] = uint32(block.timestamp + COOLDOWN_TIME) (contracts/Week1/contract3.sol#65)
        Contract3._cooldownAccounts (contracts/Week1/contract3.sol#32) can be used in cross function reentrancies:
        - Contract3.onTransferReceived(address,address,uint256,bytes) (contracts/Week1/contract3.sol#71-92)
FALSE Reentrancy in Pair.swap(uint256,uint256,address,bytes) (contracts/Week3-4/Pair.sol#209-240):
        External calls:
        - IERC20(_token0).safeTransfer(to,amount0Out) (contracts/Week3-4/Pair.sol#221)
        - IERC20(_token1).safeTransfer(to,amount1Out) (contracts/Week3-4/Pair.sol#222)
        - ICallee(to).Call(msg.sender,amount0Out,amount1Out,data) (contracts/Week3-4/Pair.sol#223)
        State variables written after the call(s):
        - _update(balance0,balance1,_reserve0,_reserve1) (contracts/Week3-4/Pair.sol#238)
                - blockTimestampLast = blockTimestamp (contracts/Week3-4/Pair.sol#150)
        Pair.blockTimestampLast (contracts/Week3-4/Pair.sol#31) can be used in cross function reentrancies:
        - Pair._update(uint256,uint256,uint112,uint112) (contracts/Week3-4/Pair.sol#113-152)
        - Pair.getReserves() (contracts/Week3-4/Pair.sol#252-256)
        - _update(balance0,balance1,_reserve0,_reserve1) (contracts/Week3-4/Pair.sol#238)
                - reserve0 = uint112(balance0) (contracts/Week3-4/Pair.sol#148)
        Pair.reserve0 (contracts/Week3-4/Pair.sol#29) can be used in cross function reentrancies:
        - Pair._update(uint256,uint256,uint112,uint112) (contracts/Week3-4/Pair.sol#113-152)
        - Pair.getReserves() (contracts/Week3-4/Pair.sol#252-256)
        - Pair.sync() (contracts/Week3-4/Pair.sol#259-261)
        - _update(balance0,balance1,_reserve0,_reserve1) (contracts/Week3-4/Pair.sol#238)
                - reserve1 = uint112(balance1) (contracts/Week3-4/Pair.sol#149)
        Pair.reserve1 (contracts/Week3-4/Pair.sol#30) can be used in cross function reentrancies:
        - Pair._update(uint256,uint256,uint112,uint112) (contracts/Week3-4/Pair.sol#113-152)
        - Pair.getReserves() (contracts/Week3-4/Pair.sol#252-256)
        - Pair.sync() (contracts/Week3-4/Pair.sol#259-261)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-1

TRUE FlashBorrower.flashBorrow(address,uint256) (contracts/Week3-4/FlashBorrower.sol#36-44) ignores return value by MyPairedToken(payToken).approve(address(lender),_allowance + _fee) (contracts/Week3-4/FlashBorrower.sol#42)
TRUE FlashBorrower.flashBorrow(address,uint256) (contracts/Week3-4/FlashBorrower.sol#36-44) ignores return value by lender.flashLoan(this,token,amount,data) (contracts/Week3-4/FlashBorrower.sol#43)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#unused-return

TRUE Contract2.constructor(address)._god (contracts/Week1/contract2.sol#14) lacks a zero-check on :
                - god = _god (contracts/Week1/contract2.sol#15)
TRUE Overmint1Attacker.constructor(address)._victim (contracts/Week2/CTF/Overmint1Attacker.sol#14) lacks a zero-check on :
                - victim = _victim (contracts/Week2/CTF/Overmint1Attacker.sol#15)
TRUE Overmint2Attacker.constructor(address)._victim (contracts/Week2/CTF/Overmint2Attacker.sol#12) lacks a zero-check on :
                - victim = _victim (contracts/Week2/CTF/Overmint2Attacker.sol#13)
TRUE Factory.constructor(address)._feeToSetter (contracts/Week3-4/Factory.sol#16) lacks a zero-check on :
                - feeToSetter = _feeToSetter (contracts/Week3-4/Factory.sol#17)
TRUE Factory.setFeeTo(address)._feeTo (contracts/Week3-4/Factory.sol#41) lacks a zero-check on :
                - feeTo = _feeTo (contracts/Week3-4/Factory.sol#43)
TRUE Factory.setFeeToSetter(address)._feeToSetter (contracts/Week3-4/Factory.sol#48) lacks a zero-check on :
                - feeToSetter = _feeToSetter (contracts/Week3-4/Factory.sol#50)
TRUE Pair.initialize(address,address)._token0 (contracts/Week3-4/Pair.sol#53) lacks a zero-check on :
                - token0 = _token0 (contracts/Week3-4/Pair.sol#55)
TRUE Pair.initialize(address,address)._token1 (contracts/Week3-4/Pair.sol#53) lacks a zero-check on :
                - token1 = _token1 (contracts/Week3-4/Pair.sol#56)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#missing-zero-address-validation

TRUE Overmint2Attacker.attack() (contracts/Week2/CTF/Overmint2Attacker.sol#17-22) has external calls inside a loop: Overmint2(victim).mint() (contracts/Week2/CTF/Overmint2Attacker.sol#19)
TRUE Overmint2Attacker.attack() (contracts/Week2/CTF/Overmint2Attacker.sol#17-22) has external calls inside a loop: Overmint2(victim).transferFrom(address(this),msg.sender,Overmint2(victim).totalSupply()) (contracts/Week2/CTF/Overmint2Attacker.sol#20)
TRUE Game.getBalance(address) (contracts/Week2/Ecosystem2/Game.sol#17-27) has external calls inside a loop: isPrime(token.tokenOfOwnerByIndex(owner,i),2) (contracts/Week2/Ecosystem2/Game.sol#23)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation/#calls-inside-a-loop

FALSE Reentrancy in Pair.burn(address) (contracts/Week3-4/Pair.sol#181-202):
        External calls:
        - IERC20(_token0).safeTransfer(to,amount0) (contracts/Week3-4/Pair.sol#195)
        - IERC20(_token1).safeTransfer(to,amount1) (contracts/Week3-4/Pair.sol#196)
        State variables written after the call(s):
        - _update(balance0,balance1,_reserve0,_reserve1) (contracts/Week3-4/Pair.sol#200)
                - price0CumulativeLast += uint256(PRBMathSD59x18.toInt(PRBMathSD59x18.div(PRBMathSD59x18.fromInt(int256(uint256(_reserve1))),PRBMathSD59x18.fromInt(int256(uint256(_reserve0)))))) * timeElapsed (contracts/Week3-4/Pair.sol#127-136)
        - _update(balance0,balance1,_reserve0,_reserve1) (contracts/Week3-4/Pair.sol#200)
                - price1CumulativeLast += uint256(PRBMathSD59x18.toInt(PRBMathSD59x18.div(PRBMathSD59x18.fromInt(int256(uint256(_reserve0))),PRBMathSD59x18.fromInt(int256(uint256(_reserve1)))))) * timeElapsed (contracts/Week3-4/Pair.sol#137-146)
FALSE Reentrancy in Pair.swap(uint256,uint256,address,bytes) (contracts/Week3-4/Pair.sol#209-240):
        External calls:
        - IERC20(_token0).safeTransfer(to,amount0Out) (contracts/Week3-4/Pair.sol#221)
        - IERC20(_token1).safeTransfer(to,amount1Out) (contracts/Week3-4/Pair.sol#222)
        - ICallee(to).Call(msg.sender,amount0Out,amount1Out,data) (contracts/Week3-4/Pair.sol#223)
        State variables written after the call(s):
        - _update(balance0,balance1,_reserve0,_reserve1) (contracts/Week3-4/Pair.sol#238)
                - price0CumulativeLast += uint256(PRBMathSD59x18.toInt(PRBMathSD59x18.div(PRBMathSD59x18.fromInt(int256(uint256(_reserve1))),PRBMathSD59x18.fromInt(int256(uint256(_reserve0)))))) * timeElapsed (contracts/Week3-4/Pair.sol#127-136)
        - _update(balance0,balance1,_reserve0,_reserve1) (contracts/Week3-4/Pair.sol#238)
                - price1CumulativeLast += uint256(PRBMathSD59x18.toInt(PRBMathSD59x18.div(PRBMathSD59x18.fromInt(int256(uint256(_reserve0))),PRBMathSD59x18.fromInt(int256(uint256(_reserve1)))))) * timeElapsed (contracts/Week3-4/Pair.sol#137-146)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-2

FALSE Reentrancy in Factory.createPair(address,address) (contracts/Week3-4/Factory.sol#23-37):
        External calls:
        - IPair(pair).initialize(tokenA,tokenB) (contracts/Week3-4/Factory.sol#33)
        Event emitted after the call(s):
        - PairCreated(tokenA,tokenB,pair) (contracts/Week3-4/Factory.sol#36)
FALSE Reentrancy in Contract4.deposit(address,uint224,address) (contracts/Week1/contract4.sol#32-38):
        External calls:
        - require(bool,string)(ERC20(token).transferFrom(msg.sender,address(this),amount),Transfer failed) (contracts/Week1/contract4.sol#34)
        Event emitted after the call(s):
        - Deposit(msg.sender,target,amount,token) (contracts/Week1/contract4.sol#37)
FALSE Reentrancy in Contract4.withdraw(address) (contracts/Week1/contract4.sol#42-57):
        External calls:
        - require(bool,string)(ERC20(token).transfer(msg.sender,availableAmount),Transfer failed) (contracts/Week1/contract4.sol#55)
        Event emitted after the call(s):
        - Withdraw(msg.sender,availableAmount,token) (contracts/Week1/contract4.sol#56)
FALSE Reentrancy in StakeNFT.withdrawNFT(uint256) (contracts/Week2/Ecosystem1/StakeNFT.sol#43-50):
        External calls:
        - nft.safeTransferFrom(address(this),msg.sender,tokenId) (contracts/Week2/Ecosystem1/StakeNFT.sol#48)
        Event emitted after the call(s):
        - WithdrawNFT(msg.sender,tokenId) (contracts/Week2/Ecosystem1/StakeNFT.sol#49)
FALSE Reentrancy in StakeNFT.withdrawTokens() (contracts/Week2/Ecosystem1/StakeNFT.sol#35-40):
        External calls:
        - token.mint(msg.sender,10) (contracts/Week2/Ecosystem1/StakeNFT.sol#38)
        Event emitted after the call(s):
        - WithdrawReward(msg.sender) (contracts/Week2/Ecosystem1/StakeNFT.sol#39)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-3

FALSE Contract3.sellTokens(uint256) (contracts/Week1/contract3.sol#50-67) uses timestamp for comparisons
        Dangerous comparisons:
        - require(bool,string)(_cooldownAccounts[msg.sender] <= uint32(block.timestamp),Please wait until the cooldown period expires) (contracts/Week1/contract3.sol#51-54)
FALSE Contract3.onTransferReceived(address,address,uint256,bytes) (contracts/Week1/contract3.sol#71-92) uses timestamp for comparisons
        Dangerous comparisons:
        - require(bool,string)(_cooldownAccounts[sender] <= uint32(block.timestamp),Please wait until the cooldown period expires) (contracts/Week1/contract3.sol#78)
FALSE Contract4.withdraw(address) (contracts/Week1/contract4.sol#42-57) uses timestamp for comparisons
        Dangerous comparisons:
        - require(bool,string)(redimeableAmount > 0 && redimeableAmount > totalWithdrawn,No available funds) (contracts/Week1/contract4.sol#50)
        - require(bool,string)(ERC20(token).transfer(msg.sender,availableAmount),Transfer failed) (contracts/Week1/contract4.sol#55)
FALSE StakeNFT.withdrawTokens() (contracts/Week2/Ecosystem1/StakeNFT.sol#35-40) uses timestamp for comparisons
        Dangerous comparisons:
        - require(bool,string)(lastWithdraw[msg.sender] + withdrawalInterval <= block.timestamp,Wait 24 hours) (contracts/Week2/Ecosystem1/StakeNFT.sol#36)
FALSE Pair._update(uint256,uint256,uint112,uint112) (contracts/Week3-4/Pair.sol#113-152) uses timestamp for comparisons
        Dangerous comparisons:
        - timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0 (contracts/Week3-4/Pair.sol#120)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#block-timestamp

TRUE Void constructor called in NFT.constructor(bytes32,uint256,address) (contracts/Week2/Ecosystem1/NFT.sol#22-26):
        - ERC721Royalty() (contracts/Week2/Ecosystem1/NFT.sol#22)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#void-constructor

FALSE Factory.createPair(address,address) (contracts/Week3-4/Factory.sol#23-37) uses assembly
        - INLINE ASM (contracts/Week3-4/Factory.sol#30-32)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#assembly-usage

FALSE Contract4._add(uint224,uint224) (contracts/Week1/contract4.sol#71-73) is never used and should be removed
FALSE Contract4._subtract(uint224,uint224) (contracts/Week1/contract4.sol#75-77) is never used and should be removed
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#dead-code

FALSE Pragma version0.8.11 (contracts/Week1/ERC1363.sol#2) allows old versions
FALSE Pragma version0.8.11 (contracts/Week1/ERC20.sol#2) allows old versions
FALSE Pragma version0.8.11 (contracts/Week1/contract1.sol#2) allows old versions
FALSE Pragma version0.8.11 (contracts/Week1/contract2.sol#2) allows old versions
FALSE Pragma version0.8.11 (contracts/Week1/contract3.sol#2) allows old versions
FALSE Pragma version0.8.11 (contracts/Week1/contract4.sol#2) allows old versions
FALSE Pragma version0.8.11 (contracts/Week2/CTF/Overmint1.sol#2) allows old versions
FALSE Pragma version0.8.11 (contracts/Week2/CTF/Overmint1Attacker.sol#2) allows old versions
FALSE Pragma version0.8.11 (contracts/Week2/CTF/Overmint2.sol#2) allows old versions
FALSE Pragma version0.8.11 (contracts/Week2/CTF/Overmint2Attacker.sol#2) allows old versions
FALSE Pragma version0.8.11 (contracts/Week2/Ecosystem1/ERC20.sol#2) allows old versions
FALSE Pragma version0.8.11 (contracts/Week2/Ecosystem1/NFT.sol#2) allows old versions
FALSE Pragma version0.8.11 (contracts/Week2/Ecosystem1/StakeNFT.sol#2) allows old versions
FALSE Pragma version0.8.11 (contracts/Week2/Ecosystem2/ERC721.sol#2) allows old versions
FALSE Pragma version0.8.11 (contracts/Week2/Ecosystem2/Game.sol#2) allows old versions
FALSE Pragma version0.8.11 (contracts/Week3-4/ERC20.sol#2) allows old versions
FALSE Pragma version0.8.11 (contracts/Week3-4/Factory.sol#2) allows old versions
FALSE Pragma version0.8.11 (contracts/Week3-4/FlashBorrower.sol#2) allows old versions
FALSE Pragma version0.8.11 (contracts/Week3-4/Pair.sol#2) allows old versions
FALSE Pragma version0.8.11 (contracts/Week3-4/interfaces/ICallee.sol#2) allows old versions
FALSE Pragma version0.8.11 (contracts/Week3-4/interfaces/IERC3156FlashBorrower.sol#2) allows old versions
FALSE Pragma version0.8.11 (contracts/Week3-4/interfaces/IERC3156FlashLender.sol#2) allows old versions
FALSE Pragma version0.8.11 (contracts/Week3-4/interfaces/IFactory.sol#2) allows old versions
FALSE Pragma version0.8.11 (contracts/Week3-4/interfaces/IPair.sol#2) allows old versions
FALSE Pragma version0.8.11 (contracts/Week3-4/libraries/Math.sol#2) allows old versions
solc-0.8.11 is not recommended for deployment
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-versions-of-solidity

TRUE Parameter Overmint1.success(address)._attacker (contracts/Week2/CTF/Overmint1.sol#21) is not in mixedCase
TRUE Constant StakeNFT.withdrawalInterval (contracts/Week2/Ecosystem1/StakeNFT.sol#19) is not in UPPER_CASE_WITH_UNDERSCORES
TRUE Constant MyEnumerableToken.maxSupply (contracts/Week2/Ecosystem2/ERC721.sol#10) is not in UPPER_CASE_WITH_UNDERSCORES
TRUE Parameter Factory.setFeeTo(address)._feeTo (contracts/Week3-4/Factory.sol#41) is not in mixedCase
TRUE Parameter Factory.setFeeToSetter(address)._feeToSetter (contracts/Week3-4/Factory.sol#48) is not in mixedCase
TRUE Parameter Pair.initialize(address,address)._token0 (contracts/Week3-4/Pair.sol#53) is not in mixedCase
TRUE Parameter Pair.initialize(address,address)._token1 (contracts/Week3-4/Pair.sol#53) is not in mixedCase
TRUE Function ICallee.Call(address,uint256,uint256,bytes) (contracts/Week3-4/interfaces/ICallee.sol#5) is not in mixedCase
TRUE Function IPair.MINIMUM_LIQUIDITY() (contracts/Week3-4/interfaces/IPair.sol#5) is not in mixedCase
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#conformance-to-solidity-naming-conventions

FALSE Variable Pair.swap(uint256,uint256,address,bytes).balance0Adjusted (contracts/Week3-4/Pair.sol#233) is too similar to Pair.swap(uint256,uint256,address,bytes).balance1Adjusted (contracts/Week3-4/Pair.sol#234)
FALSE Variable Pair.price0CumulativeLast (contracts/Week3-4/Pair.sol#33) is too similar to Pair.price1CumulativeLast (contracts/Week3-4/Pair.sol#34)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#variable-names-too-similar

FALSE Factory.createPair(address,address) (contracts/Week3-4/Factory.sol#23-37) uses literals with too many digits:
        - bytecode = type()(Pair).creationCode (contracts/Week3-4/Factory.sol#28)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#too-many-digits

FALSE Pair.SELECTOR (contracts/Week3-4/Pair.sol#23) is never used in Pair (contracts/Week3-4/Pair.sol#17-295)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#unused-state-variable

TRUE NFT.royaltyReceiver (contracts/Week2/Ecosystem1/NFT.sol#15) should be constant 
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#state-variables-that-could-be-declared-constant

TRUE Contract3.tokenA (contracts/Week1/contract3.sol#25) should be immutable 
TRUE Contract3.tokenB (contracts/Week1/contract3.sol#27) should be immutable 
TRUE FlashBorrower.lender (contracts/Week3-4/FlashBorrower.sol#15) should be immutable 
TRUE Game.token (contracts/Week2/Ecosystem2/Game.sol#10) should be immutable 
TRUE Overmint1Attacker.victim (contracts/Week2/CTF/Overmint1Attacker.sol#11) should be immutable 
TRUE Overmint2Attacker.victim (contracts/Week2/CTF/Overmint2Attacker.sol#10) should be immutable 
TRUE Pair.factory (contracts/Week3-4/Pair.sol#25) should be immutable 
TRUE StakeNFT.nft (contracts/Week2/Ecosystem1/StakeNFT.sol#15) should be immutable 
TRUE StakeNFT.token (contracts/Week2/Ecosystem1/StakeNFT.sol#14) should be immutable 
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#state-variables-that-could-be-declared-immutable

This is the conclusion only taking into account the true positives:
- **0** High severity were found
- **4** Medium severity were found
- **31** Low severity were found