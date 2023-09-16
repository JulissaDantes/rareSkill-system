// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import {IFactory} from "./interfaces/IFactory.sol";
import {Pair, IPair} from "./Pair.sol";

/// @title Factory
/// @author Julissa Dantes
/// @dev Deploys a new Pair contract given 2 token addresses
contract Factory is IFactory {
    address public feeTo;
    address public feeToSetter;

    mapping(address => mapping(address => address)) public getPair;

    //event PairCreated(address indexed tokenA, address indexed tokenB, address pair, uint);

    constructor(address _feeToSetter) {
        feeToSetter = _feeToSetter;
    }

    /// @dev Deploys a new Pair contract for the given addresses
    /// @param tokenA erc20 address, must be smaller than tokenB to save gas in writing and reading operations
    /// @param tokenB erc20 address to pair with tokenB
    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA < tokenB, "INVALID_ADDRESSES");
        require(tokenA != address(0), "ZERO_ADDRESS");
        require(getPair[tokenA][tokenB] == address(0), "PAIR_EXISTS"); // single check is sufficient because its sorted

        bytes memory bytecode = type(Pair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(tokenA, tokenB));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IPair(pair).initialize(tokenA, tokenB);
        getPair[tokenA][tokenB] = pair;

        emit PairCreated(tokenA, tokenB, pair);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, "FORBIDDEN");
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, "FORBIDDEN");
        feeToSetter = _feeToSetter;
    }
}
