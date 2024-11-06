// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {BeraCopyFactory} from "../src/BeraCopyFactory.sol";
import {BeraCopyNFT} from "../src/BeraCopyNFT.sol";
import {Test} from "forge-std/Test.sol";

contract BeraCopyFactoryTest is Test {
    BeraCopyNFT private beraCopyNFT;
    BeraCopyFactory private factory;
    address private MOCK_OWNER = address(0x123);
    address private MOCK_TARGET = address(0x234);
    // uint256 private constant tokenId = 1;

    function setUp() public {
        beraCopyNFT = new BeraCopyNFT();
        factory = new BeraCopyFactory(beraCopyNFT, MOCK_OWNER);
    }

    function test_createCopyContract() public {
        vm.prank(MOCK_OWNER);

        (address createdAddress, uint256 newTokenId, address creator, address target) =
            factory.createCopyContract(MOCK_TARGET);

        assertEq(creator, MOCK_OWNER);
        assertEq(target, MOCK_TARGET);
        assertEq(beraCopyNFT.ownerOf(newTokenId), MOCK_OWNER);

        assertEq(factory.isCreated(createdAddress), true);
        assertEq(factory.isCreated(address(0x456)), false);
    }
}
