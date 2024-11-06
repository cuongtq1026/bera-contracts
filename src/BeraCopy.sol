// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {IBeraCrocMultiSwap} from "./interfaces/IBeraCrocMultiSwap.sol";
import {BeraCopyNFT} from "./BeraCopyNFT.sol";

contract BeraCopy is AccessControl {
    event CopyTrade(address indexed dex, uint256 indexed out);

    string public constant name = "BeraCopy";
    BeraCopyNFT public beraCopyNFT;
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    uint256 public immutable tokenId;
    address public target;
    bool public paused = false;

    error CallerRestricted(address caller);
    error NotPaused();
    error ContractPaused();
    error InvalidTarget(address _target);

    constructor(uint256 _tokenId, address _minter, address _target, BeraCopyNFT _beraCopyNFT) {
        tokenId = _tokenId;
        target = _target;
        beraCopyNFT = _beraCopyNFT;

        _grantRole(MINTER_ROLE, _minter);
    }

    function pause() public onlyOwnerOrMinter {
        paused = true;
    }

    function resume() public onlyOwnerOrMinter {
        if (!paused) {
            revert NotPaused();
        }

        paused = false;
    }

    function changeTarget(address _target) public onlyOwnerOrMinter {
        if (_target == address(0) || _target == address(this)) {
            revert InvalidTarget(_target);
        }

        target = _target;
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

    function isAllowed() public view returns (bool result) {
        return isMinter() || isNFTOwner();
    }

    modifier onlyOwnerOrMinter() {
        if (!isAllowed()) {
            revert CallerRestricted(msg.sender);
        }
        _;
    }

    modifier notPaused() {
        if (paused) {
            revert ContractPaused();
        }
        _;
    }

    function multiSwap(
        IBeraCrocMultiSwap dex,
        IBeraCrocMultiSwap.SwapStep[] memory _steps,
        uint128 _amount,
        uint128 _minOut
    ) public payable onlyOwnerOrMinter notPaused returns (uint128 out) {
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
