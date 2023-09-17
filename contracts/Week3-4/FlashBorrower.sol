// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import {IERC3156FlashBorrower} from "./interfaces/IERC3156FlashBorrower.sol";
import {IERC3156FlashLender} from "./interfaces/IERC3156FlashLender.sol";
import {Pair} from "./Pair.sol";

/// This was taken from the ERC specs. See https://eips.ethereum.org/EIPS/eip-3156 for reference.
contract FlashBorrower is IERC3156FlashBorrower {
    enum Action {
        NORMAL,
        OTHER
    }

    IERC3156FlashLender lender;

    constructor(IERC3156FlashLender lender_) {
        lender = lender_;
    }

    /// @dev ERC-3156 Flash loan callback
    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external override returns (bytes32) {
        require(msg.sender == address(lender), "FlashBorrower: Untrusted lender");
        require(initiator == address(this), "FlashBorrower: Untrusted loan initiator");

        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }

    /// @dev Initiate a flash loan
    function flashBorrow(address token, uint256 amount) public {
        bytes memory data = abi.encode("");
        address payToken = token == lender.token0() ? lender.token1() : lender.token0();
        uint256 _allowance = Pair(payToken).allowance(address(this), address(lender));
        uint256 _fee = lender.flashFee(token, amount);
        uint256 _repayment = amount + _fee;
        Pair(payToken).approve(address(lender), _allowance + _repayment);
        lender.flashLoan(this, token, amount, data);
    }
}
