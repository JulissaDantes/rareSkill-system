// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import {SellERC} from "contracts/Week2/Ecosystem1/ERC20.sol";
import {NFT} from "contracts/Week2/Ecosystem1/NFT.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

/// @title Stake NFT
/// @author Julissa Dantes
/// @notice Smart contract that can mint new ERC20 tokens and receive ERC721 tokens. Users can send their NFTs and withdraw
/// 10 ERC20 tokens every 24 hours. The user can withdraw the NFT at any time. The smart contract must take possession of the
/// NFT and only the user should be able to withdraw it.
contract StakeNFT is IERC721Receiver {
    SellERC public token;
    NFT public nft;
    mapping(uint256 => address) public originalOwner;
    mapping(address => uint256) public lastWithdraw;
    mapping(address => bool) public hasStake;
    uint256 public constant withdrawalInterval = 1 days;

    event Deposit(address indexed from, uint256 tokenId);
    event WithdrawReward(address indexed from);
    event WithdrawNFT(address indexed from, uint256 tokenId);

    constructor(address _nft) {
        token = new SellERC();
        nft = NFT(_nft);
    }

    function getTokenAddress() external view returns (address) {
        return address(token);
    }

    /// @notice Transfer rewards to those who have staked an NFT. Can only be claimed every 24 hours.
    function withdrawTokens() external {
        require(lastWithdraw[msg.sender] + withdrawalInterval <= block.timestamp, "Wait 24 hours");
        lastWithdraw[msg.sender] = block.timestamp;
        token.mint(msg.sender, 10);
        emit WithdrawReward(msg.sender);
    }

    /// @notice Allows stakers to remove their NFT from the contract
    function withdrawNFT(uint256 tokenId) external {
        require(msg.sender == originalOwner[tokenId], "Not the original owner");
        hasStake[msg.sender] = false;
        delete lastWithdraw[msg.sender];
        delete originalOwner[tokenId];
        nft.safeTransferFrom(address(this), msg.sender, tokenId);
        emit WithdrawNFT(msg.sender, tokenId);
    }

    /// @notice Gets triggered when a safeTransfer is dne to the contract, and saves the deposit information
    function onERC721Received(address, address from, uint256 tokenId, bytes memory) public returns (bytes4) {
        require(msg.sender == address(nft), "Invalid NFT address");
        originalOwner[tokenId] = from;
        lastWithdraw[from] = block.timestamp;
        hasStake[from] = true;
        emit Deposit(from, tokenId);
        return 0x150b7a02;
    }
}
