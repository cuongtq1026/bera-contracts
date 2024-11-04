// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {BeraCopyNFT} from "../src/BeraCopyNFT.sol";
import {Test} from "forge-std/Test.sol";

contract BeraCopyTest is Test, BeraCopyNFT {
    address private MOCK_OWNER = address(0x123);
    uint256 private constant tokenId = 1;

    function setUp() public {}

    function test_mintNFT() public {
        _mintNFT(MOCK_OWNER, tokenId);

        assertEq(ownerOf(tokenId), MOCK_OWNER);
    }

    function test_create() public {
        uint256 newTokenId = create(MOCK_OWNER);

        assertEq(ownerOf(newTokenId), MOCK_OWNER);
    }
}
