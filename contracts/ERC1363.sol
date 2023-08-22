// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import {ERC1363, ERC20} from "erc-payable-token/contracts/token/ERC1363/ERC1363.sol";

contract BuyToken is ERC1363 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
