// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

interface IFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair);

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}
