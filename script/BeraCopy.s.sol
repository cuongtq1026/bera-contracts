// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {BeraCopy} from "../src/BeraCopy.sol";

contract BeraCopyScript is Script {
    BeraCopy public beraCopy;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        beraCopy = new BeraCopy(address(0x123));

        vm.stopBroadcast();
    }
}
