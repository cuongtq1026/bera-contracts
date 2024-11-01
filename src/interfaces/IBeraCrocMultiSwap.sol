// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

interface IBeraCrocMultiSwap {
    struct SwapStep {
        uint256 poolIdx;
        address base;
        address quote;
        bool isBuy;
    }

    function multiSwap(SwapStep[] memory _steps, uint128 _amount, uint128 _minOut)
        external
        payable
        returns (uint128 out);

    function previewMultiSwap(IBeraCrocMultiSwap.SwapStep[] calldata _steps, uint128 _amount)
        external
        view
        returns (uint128 out, uint256 predictedQty);
}
