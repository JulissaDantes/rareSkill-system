// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import {ERC721Royalty, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {BitMaps} from "@openzeppelin/contracts/utils/structs/BitMaps.sol";

contract NFT is ERC721Royalty {
    using BitMaps for BitMaps.BitMap;
    error AlreadyClaimed();
    address public royaltyReceiver;
    uint256 public constant maxSupply = 20;
    uint256 public totalSupply;
    uint256 public immutable price;
    bytes32 public immutable merkleRoot;
    BitMaps.BitMap private _claimedAddresses;

    constructor(bytes32 _merkleRoot, uint256 _price, address receiver) ERC721Royalty() ERC721("MFT","NFT") {
        _setDefaultRoyalty(receiver, 25);
        merkleRoot = _merkleRoot;
        price = _price;
    }

    function _feeDenominator() internal pure virtual override returns (uint96) {
        return 1000;
    }

    // the discount is that it only pays the royalty price
    function mint(address to, uint256 amount, bytes32[] calldata proof, uint256 index) external payable {
        require(maxSupply < maxSupply, "Max supply reached already");
        
        bool discount = false;
        // Check if discount applies
        if (verify(proof, msg.sender, index)) {
            discount = true;
            _claimedAddresses.setTo(index, true);
        }

        // Check sent amount
        require(discount ? msg.value >= price / 2 : msg.value >= price, "Invalid amount sent");
        (address receiver, uint256 royalty) = royaltyInfo(totalSupply, discount ? price / 2 : price);

        totalSupply++;
        _mint(to, amount);
        // Send royalty payment
        payable(receiver).transfer(royalty);
    }
    /// just public for testing purposes
    function verify(bytes32[] calldata proof, address sender, uint256 index) view public returns (bool ret) {
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(sender, index))));
        return MerkleProof.verify(proof, merkleRoot, leaf);
    }
}
