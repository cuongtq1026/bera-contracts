// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {IBeraCrocMultiSwap} from "./interfaces/IBeraCrocMultiSwap.sol";

contract BeraCopy {
    event CopyTrade(address indexed dex, uint256 indexed out);

    address public owner;

    constructor(address newOwner) {
        owner = newOwner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function multiSwap(
        IBeraCrocMultiSwap dex,
        IBeraCrocMultiSwap.SwapStep[] memory _steps,
        uint128 _amount,
        uint128 _minOut
    ) public payable onlyOwner returns (uint128 out) {
        uint128 result = dex.multiSwap(_steps, _amount, _minOut);

        emit CopyTrade(address(dex), result);

        return result;
    }

    function previewMultiSwap(IBeraCrocMultiSwap dex, IBeraCrocMultiSwap.SwapStep[] calldata _steps, uint128 _amount)
        public
        view
        onlyOwner
        returns (uint128 out, uint256 predictedQty)
    {
        return dex.previewMultiSwap(_steps, _amount);
    }
}
