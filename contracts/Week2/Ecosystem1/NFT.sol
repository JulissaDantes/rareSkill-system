// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import {ERC721Royalty, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {BitMaps} from "@openzeppelin/contracts/utils/structs/BitMaps.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";

/// @title NFT
/// @author Julissa Dantes
/// @notice NFT with a supply of 20. Includes ERC 2918 royalty to have a reward rate of 2.5% for any NFT in the collection.
contract NFT is ERC721Royalty, Ownable2Step {
    using BitMaps for BitMaps.BitMap;
    error AlreadyClaimed();
    address public royaltyReceiver;
    uint256 public constant maxSupply = 20;
    uint256 public totalSupply;
    uint256 public immutable price;
    bytes32 public immutable merkleRoot;
    BitMaps.BitMap private _claimedAddresses;

    constructor(bytes32 _merkleRoot, uint256 _price, address receiver) ERC721Royalty() ERC721("MFT", "NFT") {
        _setDefaultRoyalty(receiver, 25);
        merkleRoot = _merkleRoot;
        price = _price;
    }

    function _feeDenominator() internal pure virtual override returns (uint96) {
        return 1000;
    }

    function withdrawFunds() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    /// @notice Allows to mint a new token if correct rice was sent, the royalty percentage is transfered to the royalty receiver. Addresses in 
    /// a merkle tree can mint NFTs at a discount. 
    /// @param to The address to mint to
    /// @param tokenId the tokenId to mint
    /// @param proof The proof that the account is inside the tree
    /// @param secret A secret data given to the address to prove its involvement
    function mint(address to, uint256 tokenId, bytes32[] calldata proof, uint256 secret) external payable {
        require(totalSupply < maxSupply, "Max supply reached already");

        bool discount = false;
        // Check if discount applies
        if (verify(proof, msg.sender, secret)) {
            discount = true;
            _claimedAddresses.setTo(secret, true);
        }

        // Check sent amount
        require(discount ? msg.value >= price / 2 : msg.value >= price, "Invalid amount sent");
        (address receiver, uint256 royalty) = royaltyInfo(totalSupply, discount ? price / 2 : price);

        totalSupply++;
        _mint(to, tokenId);
        // Send royalty payment
        payable(receiver).transfer(royalty);
    }

    /// @notice Verify is an address is inside the merkle tree
    /// @dev public for testing purposes
    /// @param proof The proof that the account is inside the tree
    /// @param sender The address to check
    /// @param secret A secret data given to the address to prove its involvement
    function verify(bytes32[] calldata proof, address sender, uint256 secret) public view returns (bool ret) {
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(sender, secret))));
        return MerkleProof.verify(proof, merkleRoot, leaf);
    }
}
