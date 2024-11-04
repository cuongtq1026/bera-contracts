// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract BeraCopyNFT is ERC721URIStorage {
    uint256 private _nextTokenId;

    constructor() ERC721("BeraCopyNFT", "BCY") {}

    function create(address receiver) public returns (uint256) {
        uint256 tokenId = _nextTokenId++;
        _mintNFT(receiver, tokenId);

        return tokenId;
    }

    function _mintNFT(address to, uint256 tokenId) internal {
        _mint(to, tokenId);
    }
}
