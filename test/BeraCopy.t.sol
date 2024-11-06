// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {IBeraCrocMultiSwap} from "../src/interfaces/IBeraCrocMultiSwap.sol";
import {BeraCopy} from "../src/BeraCopy.sol";
import {BeraCopyNFT} from "../src/BeraCopyNFT.sol";

contract BeraCopyTest is Test, BeraCopyNFT {
    BeraCopy public beraCopy;
    MockBeraCrocMultiSwap public mockDex;

    address private MOCK_OWNER = address(0x123);
    address private MOCK_TARGET = address(0x234);
    address private MOCK_NFT_OWNER = address(0x345);
    uint256 private constant tokenId = 1;

    function setUp() public {
        _mintNFT(MOCK_NFT_OWNER, tokenId); // Mint NFT to MOCK_OWNER

        mockDex = new MockBeraCrocMultiSwap();
        beraCopy = new BeraCopy(tokenId, MOCK_OWNER, MOCK_TARGET, this);

        vm.prank(MOCK_OWNER);
        beraCopy.setBeraCopyNFT(address(this));
    }

    function test_name() public {
        assertEq(beraCopy.name(), "BeraCopy");
    }

    function test_isMinter() public {
        vm.prank(MOCK_OWNER);
        assertEq(beraCopy.isMinter(), true);

        address RESTRICTED_ADDRESS = address(0x1234);

        vm.prank(RESTRICTED_ADDRESS);
        assertEq(beraCopy.isMinter(), false);
    }

    function test_isNFTOwner() public {
        vm.prank(MOCK_NFT_OWNER);

        assertEq(beraCopy.isNFTOwner(), true);

        address RESTRICTED_ADDRESS = address(0x1234);

        vm.prank(RESTRICTED_ADDRESS);
        bool isOwner = beraCopy.isNFTOwner();

        assertEq(beraCopy.isNFTOwner(), false);
    }

    function test_isAllowed() public {
        vm.prank(MOCK_OWNER);
        assertEq(beraCopy.isAllowed(), true);

        vm.prank(MOCK_NFT_OWNER);
        assertEq(beraCopy.isAllowed(), true);

        address RESTRICTED_ADDRESS = address(0x1234);
        assertEq(beraCopy.isAllowed(), false);
    }

    function test_SameTarget() public {
        assertEq(beraCopy.target(), MOCK_TARGET);
    }

    function test_changeTarget() public {
        vm.prank(MOCK_OWNER);

        address NEW_MOCK_TARGET = address(0x2345);
        beraCopy.changeTarget(NEW_MOCK_TARGET);

        assertEq(beraCopy.target(), NEW_MOCK_TARGET);

        // zero address case
        vm.prank(MOCK_OWNER);

        address ZERO_ADDRESS = address(0);
        vm.expectRevert(abi.encodeWithSelector(BeraCopy.InvalidTarget.selector, ZERO_ADDRESS));
        beraCopy.changeTarget(ZERO_ADDRESS);

        // self target case
        vm.prank(MOCK_OWNER);

        address SELF_ADDRESS = address(beraCopy);
        vm.expectRevert(abi.encodeWithSelector(BeraCopy.InvalidTarget.selector, SELF_ADDRESS));
        beraCopy.changeTarget(SELF_ADDRESS);

        // not allowed case
        address RESTRICTED_ADDRESS = address(0x1234);
        vm.prank(RESTRICTED_ADDRESS);

        vm.expectRevert(abi.encodeWithSelector(BeraCopy.CallerRestricted.selector, RESTRICTED_ADDRESS));
        beraCopy.changeTarget(NEW_MOCK_TARGET);
    }

    function test_setBeraCopyNFT() public {
        BeraCopyNFT newBeraCopyNFT = new BeraCopyNFT();
        address newNFTAddress = address(newBeraCopyNFT);

        vm.prank(MOCK_OWNER);
        beraCopy.setBeraCopyNFT(newNFTAddress);

        assertEq(address(beraCopy.beraCopyNFT()), newNFTAddress);
    }

    function test_isPausedOnSetup() public {
        assertEq(beraCopy.paused(), false);
    }

    function test_pauseCall() public {
        vm.prank(MOCK_OWNER);
        beraCopy.pause();

        assertEq(beraCopy.paused(), true);
    }

    function test_resumeCall() public {
        vm.prank(MOCK_OWNER);
        beraCopy.pause();

        vm.prank(MOCK_OWNER);
        beraCopy.resume();

        assertEq(beraCopy.paused(), false);
    }

    function test_resumeOnNotPaused() public {
        vm.prank(MOCK_OWNER);

        vm.expectRevert(BeraCopy.NotPaused.selector);
        beraCopy.resume();
    }

    function test_MultiSwap() public {
        vm.prank(MOCK_OWNER);

        IBeraCrocMultiSwap.SwapStep[] memory steps = new IBeraCrocMultiSwap.SwapStep[](1);
        steps[0] = IBeraCrocMultiSwap.SwapStep(1234, address(0x1), address(0x2), true);

        uint128 amount = 1000;
        uint128 minOut = 500;

        uint128 result = beraCopy.multiSwap(mockDex, steps, amount, minOut);
        // uint128 result = mockDex.multiSwap(steps, amount, minOut);
        assertEq(result, 12345);
    }

    function test_MultiSwapOnPaused() public {
        // Impersonate MOCK_OWNER for the call
        vm.prank(MOCK_OWNER);
        // call pause()
        beraCopy.pause();

        IBeraCrocMultiSwap.SwapStep[] memory steps = new IBeraCrocMultiSwap.SwapStep[](1);
        steps[0] = IBeraCrocMultiSwap.SwapStep(1234, address(0x1), address(0x2), true);

        uint128 amount = 1000;
        uint128 minOut = 500;

        // Impersonate MOCK_OWNER for the call
        vm.prank(MOCK_OWNER);
        vm.expectRevert(BeraCopy.ContractPaused.selector);
        uint128 result = beraCopy.multiSwap(mockDex, steps, amount, minOut);
    }
}

contract MockBeraCrocMultiSwap is IBeraCrocMultiSwap {
    function multiSwap(IBeraCrocMultiSwap.SwapStep[] memory, uint128, uint128) public payable returns (uint128) {
        return 12345;
    }

    function previewMultiSwap(IBeraCrocMultiSwap.SwapStep[] calldata, uint128)
        public
        pure
        returns (uint128 out, uint256 predictedQty)
    {
        return (12345, 45678);
    }
}
