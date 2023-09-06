// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract MyEnumerableToken is ERC721, ERC721Enumerable {
    constructor() ERC721("MyEnumerableToken", "MTK") {}

    uint256 public constant maxSupply = 20;

    function mint(address to) external payable {
        require(totalSupply() <= maxSupply, "Max supply reached already");
        // TODO handle when some token gets burned, in that case this minting id doesnt work
        _mint(to, totalSupply() + 1);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        if (from == address(0)) {}
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
