// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {IBeraCrocMultiSwap} from "./interfaces/IBeraCrocMultiSwap.sol";

contract BeraCopy {
    address public owner;

    constructor(address newOwner) {
        owner = newOwner;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function multiSwap(
        IBeraCrocMultiSwap dex,
        IBeraCrocMultiSwap.SwapStep[] memory _steps,
        uint128 _amount,
        uint128 _minOut
    ) onlyOwner public payable returns (uint128 out) {
        return dex.multiSwap(_steps, _amount, _minOut);
    }

    function previewMultiSwap(
        IBeraCrocMultiSwap dex,
        IBeraCrocMultiSwap.SwapStep[] calldata _steps,
        uint128 _amount
    ) onlyOwner public view returns (uint128 out, uint256 predictedQty) {
        return dex.previewMultiSwap(_steps, _amount);
    }
}
