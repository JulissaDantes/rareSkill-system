// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Checkpoints.sol";

/*
* Untrusted escrow. Create a contract where a buyer can put an *arbitrary* ERC20 token into a 
* contract and a seller can withdraw it 3 days later. 
*/
contract Contract4 {
    using Checkpoints for Checkpoints.Trace224;
    // account address => (token address => amount in time)
    mapping(address => mapping(address => Checkpoints.Trace224)) private usersFunds;

    function deposit(address target, uint256 amount, address token) external {
        // transfer token to the contract
        ERC20(token).transferFrom(msg.sender, address(this), amount);
        //update state
        updateFunds(usersFunds[target][token], _add, amount);
    }

    function withdraw(address token) external {
        // The biggest timestamp that can fit a uint 32 is April 16, 2106, therefore this conversion wont cause problems
        uint32 time = uint32(block.timestamp - 3 days);
        uint256 availableAmount = usersFunds[msg.sender][token].upperLookupRecent(time);
        require(availableAmount > 0, "No available funds");
        
        updateFunds(usersFunds[msg.sender][token], _subtract, availableAmount);
        ERC20(token).transfer(msg.sender, availableAmount);
    }

    function updateFunds( Checkpoints.Trace224 storage store, function(uint224, uint224) view returns (uint224) op, uint256 amount) internal {
       
    }

    function _add(uint224 a, uint224 b) private pure returns (uint224) {
        return a + b;
    }

    function _subtract(uint224 a, uint224 b) private pure returns (uint224) {
        return a - b;
    }
}
