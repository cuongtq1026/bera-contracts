// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {AccessControl} from "../dependencies/@openzeppelin-contracts-5.0.2/access/AccessControl.sol";
import {IBeraCrocMultiSwap} from "./interfaces/IBeraCrocMultiSwap.sol";
import {BeraCopyNFT} from "./BeraCopyNFT.sol";

contract BeraCopy is AccessControl {
    BeraCopyNFT public beraCopyNFT;

    event CopyTrade(address indexed dex, uint256 indexed out);

    uint256 public tokenId;
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    error CallerRestricted(address caller);

    constructor(uint256 _tokenId, address minter, BeraCopyNFT _beraCopyNFT) {
        tokenId = _tokenId;
        beraCopyNFT = _beraCopyNFT;

        _grantRole(MINTER_ROLE, minter);
    }

    function isMinter() public view returns (bool result) {
        return hasRole(MINTER_ROLE, msg.sender);
    }

    function isNFTOwner() public view returns (bool result) {
        return beraCopyNFT.ownerOf(tokenId) == msg.sender;
    }

    function setBeraCopyNFT(address addr) public onlyOwnerOrMinter {
        beraCopyNFT = BeraCopyNFT(addr);
    }

    modifier onlyOwnerOrMinter() {
        require(isMinter() || isNFTOwner(), CallerRestricted(msg.sender));
        _;
    }

    function multiSwap(
        IBeraCrocMultiSwap dex,
        IBeraCrocMultiSwap.SwapStep[] memory _steps,
        uint128 _amount,
        uint128 _minOut
    ) public payable onlyOwnerOrMinter returns (uint128 out) {
        uint128 result = dex.multiSwap(_steps, _amount, _minOut);

        emit CopyTrade(address(dex), result);

        return result;
    }

    function previewMultiSwap(IBeraCrocMultiSwap dex, IBeraCrocMultiSwap.SwapStep[] calldata _steps, uint128 _amount)
        public
        view
        onlyOwnerOrMinter
        returns (uint128 out, uint256 predictedQty)
    {
        return dex.previewMultiSwap(_steps, _amount);
    }
}
