// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {CommonBase} from "../lib/forge-std/src/Base.sol";
import {Script} from "../lib/forge-std/src/Script.sol";
import {StdChains} from "../lib/forge-std/src/StdChains.sol";
import {StdCheatsSafe} from "../lib/forge-std/src/StdCheats.sol";
import {StdUtils} from "../lib/forge-std/src/StdUtils.sol";
import {console} from "../lib/forge-std/src/console.sol";
import {BeraCopyFactory} from "../src/BeraCopyFactory.sol";
import {BeraCopyNFT} from "../src/BeraCopyNFT.sol";

contract DeployBeraCopyFactoryScript is Script {
    function setUp() public {}

    function run() public {
        // Start the broadcast to deploy the contract
        vm.startBroadcast();

        // Deploy BeraCopyNFT instance
        BeraCopyNFT beraCopyNFT = new BeraCopyNFT();

        // Deploy BeraCopyFactory with the BeraCopyNFT instance
        BeraCopyFactory factory = new BeraCopyFactory(beraCopyNFT, msg.sender);

        // Stop broadcasting
        vm.stopBroadcast();

        // Optional: Print the address of the deployed contract
        console.log("BeraCopyNFT deployed to:", address(beraCopyNFT));
        console.log("BeraCopyFactory deployed to:", address(factory));
    }
}
