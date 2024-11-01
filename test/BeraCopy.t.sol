// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {BeraCopy} from "../src/BeraCopy.sol";

contract BeraCopyTest is Test {
    BeraCopy public beraCopy;
    address private MOCK_OWNER = address(0x123);

    function setUp() public {
        beraCopy = new BeraCopy(MOCK_OWNER);
    }

    function test_Owner() public {
        assertEq(beraCopy.owner(), MOCK_OWNER);
    }
}
