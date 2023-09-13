// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import {IFactory} from "./interfaces/IFactory.sol";
import {Pair, IPair} from "./Pair.sol";
import "hardhat/console.sol";

/// @title Factory
/// @author Julissa Dantes
/// @notice Deploys a new Pair contract given 2 token addresses
contract Factory is IFactory {
    address public feeTo;
    address public feeToSetter;

    mapping(address => mapping(address => address)) public getPair;

    //event PairCreated(address indexed tokenA, address indexed tokenB, address pair, uint);

    constructor(address _feeToSetter) {
        feeToSetter = _feeToSetter;
    }

    /// @notice Deploys a new Pair contract for the given addresses
    /// @param tokenA erc20 address, must be smaller than tokenB to save gas in writing and reading operations
    /// @param tokenB erc20 address to pair with tokenB
    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA < tokenB, 'INVALID_ADDRESSES');
        require(tokenA != address(0), 'ZERO_ADDRESS');
        require(getPair[tokenA][tokenB] == address(0), 'PAIR_EXISTS'); // single check is sufficient because its sorted

        Pair newPair = new Pair();  // Deploy a new Pair contract
        newPair.initialize(tokenA, tokenB);
        pair = address(newPair);
        getPair[tokenA][tokenB] = pair;

        emit PairCreated(tokenA, tokenB, pair);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, 'FORBIDDEN');
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, 'FORBIDDEN');
        feeToSetter = _feeToSetter;
    }
}