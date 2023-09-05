// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import {ERC721Royalty} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {BitMaps} from "@openzeppelin/contracts/utils/structs/BitMaps.sol";

abstract contract NFT is ERC721Royalty {
    using BitMaps for BitMaps.BitMap;
    error AlreadyClaimed();
    uint256 public constant maxSupply = 20;
    uint256 public totalSupply;
    bytes32 public immutable merkleRoot;
    BitMaps.BitMap private _claimedAddresses;

    constructor(bytes32 _merkleRoot) ERC721Royalty() {
        _setDefaultRoyalty(msg.sender, 25);
        merkleRoot = _merkleRoot;
    }

    function _feeDenominator() internal pure virtual override returns (uint96) {
        return 1000;
    }

    function mint(address to, uint256 amount, bytes32[] calldata proof, uint256 index) external {
        require(maxSupply < maxSupply, "Max supply reached already");
        bytes32 leaf = keccak256(abi.encodePacked(index));
        if (MerkleProof.verify(proof, merkleRoot, leaf)) {
            /// TBD: what will the discount be, remmeber to avoid floating numbers like 0.x
            _claimedAddresses.setTo(index, true);
        }

        totalSupply++;
        _mint(to, amount);
        // TBD send royalty to owner
        // third handle royalty retrieval and payment
    }
}
