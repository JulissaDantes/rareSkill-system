// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title Token with god mode
/// @author Julissa Dantes
/// @dev A special address assigned at deployment is able to transfer tokens between addresses at will.
contract Contract2 is ERC20("GodToken", "GTK") {
    address immutable god;

    event CustomTransfer(address indexed from, address indexed to, uint256 value);

    constructor(address _god) {
        god = _god;
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    /// @dev Behaves just like transferFrom but bypasses the from check. Only god account can perform this transfer.
    function customTransfer(address from, address to, uint256 value) external returns (bool result) {
        require(msg.sender == god);
        uint256 allowance = allowance(from, to);
        if (allowance >= value) {
            _spendAllowance(from, to, value);
        } else {
            _spendAllowance(from, to, allowance);
        }
        emit CustomTransfer(from, to, value);
        _transfer(from, to, value);
        result = true;
    }
}
