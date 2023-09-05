// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import {SellToken} from "contracts/Week2/Ecosystem1/ERC20.sol";
import {NFT} from "contracts/Week2/Ecosystem1/NFT.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

/*
* 
    - [ ] Create and a third smart contract that can mint new ERC20 tokens and receive ERC721 tokens. Users can send their NFTs and withdraw 
    10 ERC20 tokens every 24 hours.
    The user can withdraw the NFT at any time. The smart contract must take possession of the NFT and only the user should be able to withdraw 
    it. 
    
    **IMPORTANT**: your staking mechanism must follow the sequence in the video I recorded above (stake NFTs with safetransfer).
    - [ ] Make the funds from the NFT sale in the contract withdrawable by the owner. Use Ownable2Step. Remember to override the renounce to 
    avoid tokens getting lost
*/
abstract contract StakeNFT is Ownable2Step, IERC721Receiver {
    SellToken public token;
    NFT public nft;
    mapping(uint256 => address) public originalOwner;
    mapping(address => uint256) public lastWithdraw;
    mapping(address => bool) public hasStake;
    uint256 public constant withdrawalInterval = 1 days;

    constructor(address _nft) {
        token = new SellToken();
        nft = NFT(_nft);
    }

    function onERC721Received(
        address,
        address from,
        uint256 tokenId,
        bytes memory
    ) public returns (bytes4) {
        require(msg.sender == address(nft), "Invalid NFT address");
        originalOwner[tokenId] = from;
        lastWithdraw[from] = block.timestamp;
        hasStake[from] = true;
        return 0x150b7a02;
    }

    function withdrawTokens() external {
        require(lastWithdraw[msg.sender] + withdrawalInterval >= block.timestamp);
        lastWithdraw[msg.sender] = block.timestamp;
        token.mint(msg.sender, 10);
    }

    function withdrawNFT(uint256 tokenId) external {
        require(msg.sender == originalOwner[tokenId], "Not the original owner");
        hasStake[msg.sender] = false;
        delete lastWithdraw[msg.sender];
        delete originalOwner[tokenId];
        nft.safeTransferFrom(address(0), msg.sender, tokenId);
    }

    function withdraw() external onlyOwner {
        
    }
}
