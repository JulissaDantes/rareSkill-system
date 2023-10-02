# rareSkill-system
I am currently enrolled in RareSkills bootcamp and this repo is for the projects I make while I'm at it.

# Study

- [X]  Watch Trail of Bits Echidna tutorial part 1 ([link](https://www.youtube.com/watch?v=QofNQxW_K08&list=PLciHOL_J7Iwqdja9UH4ZzE8dP1IxtsBXI&index=1))
- [X]  Watch Trail of Bits Echidna tutorial part 2 ([link](https://www.youtube.com/watch?v=9P7sqE6hILM&list=PLciHOL_J7Iwqdja9UH4ZzE8dP1IxtsBXI&index=2))
- [X]  Read Trail of Bits Echidna introduction ([link](https://github.com/crytic/building-secure-contracts/tree/master/program-analysis/echidna/introduction))
- [X]  Read Trail of Bits Echidna basic ([link](https://github.com/crytic/building-secure-contracts/tree/master/program-analysis/echidna/basic))
- [X]  Read Echidna tips ([link](https://github.com/crytic/building-secure-contracts/blob/master/program-analysis/echidna/fuzzing_tips.md))
- [X]  Read Echidna FAQ ([link](https://github.com/crytic/building-secure-contracts/blob/master/program-analysis/echidna/frequently_asked_questions.md))
- [X]  Optional reading: Echidna exercises ([link](https://github.com/crytic/building-secure-contracts/tree/master/program-analysis/echidna/exercises))

# Practice

- [X]  Echidna exercise 1 ([link](https://github.com/crytic/building-secure-contracts/blob/master/program-analysis/echidna/exercises/Exercise-1.md))
- [ ]  Echidna exercise 2 ([link](https://github.com/crytic/building-secure-contracts/blob/master/program-analysis/echidna/exercises/Exercise-2.md))
- [ ]  Echidna exercise 3 ([link](https://github.com/crytic/building-secure-contracts/blob/master/program-analysis/echidna/exercises/Exercise-3.md))
- [ ]  Echidna exercise 4 ([link](https://github.com/crytic/building-secure-contracts/blob/master/program-analysis/echidna/exercises/Exercise-4.md))
- [ ]  Solve Capture the Ether token Whale ([link](https://capturetheether.com/challenges/math/token-whale/))

**Tips**

- If you get stuck on the Echidna exercises, go ahead and look up the answer in solution.sol. But don’t jump straight to the answer or your brain won’t grok the problem fully.
- You will need to use a solidity version earlier than 0.8.0
- You will have to update some of the syntax to match the older version
- You can use the `isComplete` as the assert and invariant condition
- You will likely need to run echidna longer with `echidna-test your-solution.sol --test-limit <larger limit>`
- [ ]  Solve Problem 22: DEX 1 from Capture the Ether ([link](https://ethernaut.openzeppelin.com/level/22))

**Tips**

- Solidity version should be 0.8.0 or higher
- Set this up in a hardhat environment
- Be mindful if you should be using `msg.sender` or `address(this)`
- You will need to set up a contract that creates the same setup ethernaut does
- After you setup the contract that sets up the environment use this command `echidna-test . --config config.yaml --contract SetupContract`
- Hint: the `swap` function takes two arbitrary addresses, but only two are valid. How can you alter the wrapper function to ensure the fuzzer doesn’t try invalid values?
- The contract will need to renounce ownership of the dex it creates, otherwise it would be cheating to hack a contract you have ownership over
- Hint: Rather than checking if you completely drained the contract, maybe check if the pool has a lot less liquidity than expected? This will make it easier to find the exploit
- Echidna remembers interesting transactions from the corpus directory.
- Hint: Echidna uses what addresses as `msg.sender` by default? How many are needed? Can we speed up the fuzzing by changing this number?
- **Writeup**: do a writeup of what the fuzzer found
- [ ]  Use Echidna to test the bonding curve from the ERC20 of the first week. What invariants should you use?

# When you are done

- [ ]  Format your code and publish to github.
- [ ]  Make sure your solution solidity files and config.yml files for each problem are ready to review
- [ ]  Set up a 1-1 with your instructor to review Week 3 and 4