// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import {ERC721Royalty} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import {BitMaps} from "@openzeppelin/contracts/utils/structs/BitMaps.sol";

abstract contract NFT is ERC721Royalty {
    using BitMaps for BitMaps.BitMap;
    error AlreadyClaimed();
    uint256 public constant maxSupply = 20;
    uint256 public totalSupply;
    BitMaps.BitMap private _claimedAddresses;

    constructor() ERC721Royalty() {
        _setDefaultRoyalty(msg.sender, 25);
    }

    function _feeDenominator() internal pure virtual override returns (uint96) {
        return 1000;
    }

    function mint(address to, uint256 amount) external {
        require(maxSupply < maxSupply, "Max supply reached already");
        // first make sure address is inside merkle tree
        // second set the bit map value as claimed
        totalSupply++;
        _mint(to, amount);
        // third handle royalty retrieval and payment
    }
}
