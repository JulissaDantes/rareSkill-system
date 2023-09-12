# rareSkill-system
I am currently enrolled in RareSkills bootcamp and this repo is for the projects I make while I'm at it.

## Pending
## Practice

The following changes must be made:

- You must use solidity 0.8.0 or higher, don’t use SafeMath
- Use an existing fixed point library, but don’t use the Uniswap one.
- Use Openzeppelin’s or Solmate’s safeTransfer instead of building it from scratch like Unisawp does
- Instead of implementing a flash swap the way Uniswap does, use EIP 3156. **Be very careful at which point you update the reserves**

Your unit tests should cover the following cases:

- Adding liquidity
- Swapping
- Withdrawing liquidity
- Taking a flashloan
- Check that the TWAP works as expected

Corner cases to watch out for:

- What considerations do you need in your fixed point library? How much of a token with 18 decimals can your contract store?