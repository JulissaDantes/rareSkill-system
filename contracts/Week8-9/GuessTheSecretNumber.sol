pragma solidity ^0.4.21;

/*
Putting the answer in the code makes things a little too easy.

This time I’ve only stored the hash of the number. Good luck reversing a cryptographic hash!
*/

contract GuessTheSecretNumberChallenge {
    bytes32 answerHash = 0xdb81b4d58595fbbbb592d3661a34cdca14d7ab379441400cbfa1b78bc447c365;

    function GuessTheSecretNumberChallenge() public payable {
        require(msg.value == 1 ether);
    }

    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }

    function guess(uint8 n) public payable {
        require(msg.value == 1 ether);

        if (keccak256(n) == answerHash) {
            msg.sender.transfer(2 ether);
        }
    }
}

/*
Solution: Compute number in the same transaction.
*/
contract GuessTheSecretNumberChallengeAttacker {
    address victim;
    bytes32 answerHash = 0xdb81b4d58595fbbbb592d3661a34cdca14d7ab379441400cbfa1b78bc447c365;

    function setVictim(address _victim) external {
        victim = _victim;
    }

    function attack() payable external {
        uint8 n = 0;
        while (n < 255) {//max uint8 value
            if (keccak256(n) == answerHash) {
                break;
            }
            n++;
        }
        GuessTheSecretNumberChallenge(victim).guess.value(msg.value)(n);
    }

    function() payable public {
    }
}
