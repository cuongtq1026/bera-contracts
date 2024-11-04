// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import {IBeraCrocMultiSwap} from "../src/interfaces/IBeraCrocMultiSwap.sol";
import {BeraCopy} from "../src/BeraCopy.sol";
import {BeraCopyNFT} from "../src/BeraCopyNFT.sol";

contract BeraCopyTest is Test, BeraCopyNFT {
    BeraCopy public beraCopy;
    MockBeraCrocMultiSwap public mockDex;

    address private MOCK_OWNER = address(0x123);
    uint256 private constant tokenId = 1;

    function setUp() public {
        _mintNFT(MOCK_OWNER, tokenId); // Mint NFT to MOCK_OWNER

        mockDex = new MockBeraCrocMultiSwap();
        beraCopy = new BeraCopy(tokenId, MOCK_OWNER);

        vm.prank(MOCK_OWNER);
        beraCopy.setBeraCopyNFT(address(this));
    }

    function test_isMinter() public {
        vm.prank(MOCK_OWNER);
        assertEq(beraCopy.isMinter(), true);
    }

    function test_isNFTOwner() public {
        // Impersonate MOCK_OWNER to call isNFTOwner
        vm.prank(MOCK_OWNER);
        bool isOwner = beraCopy.isNFTOwner();

        assertEq(isOwner, true);
    }

    function test_MultiSwap() public {
        // Impersonate MOCK_OWNER for the call
        vm.prank(MOCK_OWNER);

        IBeraCrocMultiSwap.SwapStep[] memory steps = new IBeraCrocMultiSwap.SwapStep[](1);
        steps[0] = IBeraCrocMultiSwap.SwapStep(1234, address(0x1), address(0x2), true);

        uint128 amount = 1000;
        uint128 minOut = 500;

        uint128 result = beraCopy.multiSwap(mockDex, steps, amount, minOut);
        // uint128 result = mockDex.multiSwap(steps, amount, minOut);
        assertEq(result, 12345);
    }
}

contract MockBeraCrocMultiSwap is IBeraCrocMultiSwap {
    function multiSwap(IBeraCrocMultiSwap.SwapStep[] memory, uint128, uint128)
        public
        payable
        returns (uint128)
    {
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
