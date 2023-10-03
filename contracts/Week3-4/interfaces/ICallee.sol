// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

interface ICallee {
    function Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
}