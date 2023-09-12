# rareSkill-system
I am currently enrolled in RareSkills bootcamp and this repo is for the projects I make while I'm at it.

## Pending

Your goal is to remake Uniswap V2 core: https://github.com/Uniswap/v2-core/tree/master/contracts
## Practice

The following changes must be made:

- You must use solidity 0.8.0 or higher, don’t use SafeMath DONE
- Use an existing fixed point library, but don’t use the Uniswap one.
- Use Openzeppelin’s or Solmate’s safeTransfer instead of building it from scratch like Unisawp does DONE
- Instead of implementing a flash swap the way Uniswap does, use EIP 3156. **Be very careful at which point you update the reserves**

Your unit tests should cover the following cases:

- Adding liquidity
- Swapping
- Withdrawing liquidity
- Taking a flashloan
- Check that the TWAP works as expected
- Add natspec for all the complex functions
- Create readme for week 3 folder
- reorder functions by visibility

Corner cases to watch out for:

- What considerations do you need in your fixed point library? How much of a token with 18 decimals can your contract store?

## Recommended Reading Afterwards

Here are the audits done on Uniswap V2. Each of these audits has two medium or higher issues, I suggest focusing on those.

- https://github.com/Consensys/Uniswap-audit-report-2018-12/blob/master/Uniswap-final.md#4-issue-detail
- https://rskswap.com/audit.html#org56963b6