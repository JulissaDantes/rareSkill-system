// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;
// OpenZeppelin version used: 4.9.3
import {ERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract MyPairedToken is ERC20, ERC20Permit {
    constructor() ERC20("MyPairedToken", "MTK") ERC20Permit("MyToken") {}

    function mint(uint256 amount) external {
        _mint(msg.sender, amount);
    }
}
