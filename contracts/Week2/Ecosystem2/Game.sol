// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract Game {
    ERC721Enumerable public token;

    constructor(address _token) {
        token = ERC721Enumerable(_token);
    }

    // Create a second smart contract that has a function which accepts an address
    // and returns how many NFTs are owned by that address which have tokenIDs that are prime
    // numbers. For example, if an address owns tokenIds 10, 11, 12, 13, it should return 2.
    function getBalance(address owner) external view returns (uint256 amount) {
        // get all nfts first
        uint256 balance = token.balanceOf(owner);
        // count prime numbered tokenIds
        for (uint i = 0; i < balance; i++) {
            // Sending a 2 for the isPrime function to start the progressive count to the actual tokenId number
            if (isPrime(token.tokenOfOwnerByIndex(owner, i), 2)) {
                amount++;
            }
        }
    }

    // Helper function to check if a number is prime, by checking if its divisible by any of the numbers
    // less than the number itself.
    function isPrime(uint256 n, uint256 i) internal pure returns (bool) {
        if (n <= 2) return (n == 2) ? true : false;
        if (n % i == 0) return false;
        if (i * i > n) return true;

        // Check for next divisor
        return isPrime(n, i + 1);
    }
}
