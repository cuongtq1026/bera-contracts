// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {BeraCopy} from "../src/BeraCopy.sol";

contract BeraCopyScript is Script {
    BeraCopy public beraCopy;

    address private MOCK_OWNER = address(0x123);
    uint256 private constant tokenId = 1;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        beraCopy = new BeraCopy(tokenId, MOCK_OWNER);

        vm.stopBroadcast();
    }
}
