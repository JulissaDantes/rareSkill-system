# rareSkill-system
I am currently enrolled in RareSkills bootcamp and this repo is for the projects I make while I'm at it.

TODO:
- [X]  Run Slither on the codebases you created in the last two weeks
- [X]  Run MythX on any of the codebases of your chosing
- [X]  **Markdown 1**** Document true and false positives that you discovered with the tools
- [ ]  Ensure the ERC721 / ERC20 / Staking application has 100% line and branch coverage
- [ ]  **Markdown 2:** Run [vertigo-rs](https://github.com/RareSkills/vertigo-rs) to do mutation testing on the ERC721 / ERC20 / Staking application. What mutations do you discover?

### Hints for Vertigo

- use `--sample-ratio 0.1` when testing so you don’t have to wait a long time for it to finish. Then let it run the entire set of mutations without that argument
- use `--output my_file` to save the output because some shells don’t show the output

## Recommended Reading Afterwards

Here are the audits done on Uniswap V2. Each of these audits has two medium or higher issues, I suggest focusing on those.

- https://github.com/Consensys/Uniswap-audit-report-2018-12/blob/master/Uniswap-final.md#4-issue-detail
- https://rskswap.com/audit.html#org56963b6