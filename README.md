# rareSkill-system
I am currently enrolled in RareSkills bootcamp and this repo is for the projects I make while I'm at it.

## Pending

Your goal is to remake Uniswap V2 core: https://github.com/Uniswap/v2-core/tree/master/contracts
## Practice

The following changes must be made:
- Instead of implementing a flash swap the way Uniswap does, use EIP 3156. **Be very careful at which point you update the reserves**

Your unit tests should cover the following cases:

- Taking a flashloan

TODO:
- Add natspec for all the complex functions
- Create readme for week 3 folder
- reorder functions by visibility
- check attacks to v2 to make sure my version works against that
- fill survey on assignment page
- add tests for events
- add tests for all reverts

Corner cases to watch out for:

- What considerations do you need in your fixed point library? How much of a token with 18 decimals can your contract store?

## Recommended Reading Afterwards

Here are the audits done on Uniswap V2. Each of these audits has two medium or higher issues, I suggest focusing on those.

- https://github.com/Consensys/Uniswap-audit-report-2018-12/blob/master/Uniswap-final.md#4-issue-detail
- https://rskswap.com/audit.html#org56963b6