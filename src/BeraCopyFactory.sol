// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./BeraCopyNFT.sol";
import {BeraCopy} from "./BeraCopy.sol";

contract BeraCopyFactory {
    event CopyTradeCreated(address indexed createdAddress, address indexed creator, uint256 indexed tokenId);

    BeraCopyNFT public beraCopyNFT;
    mapping(address => bool) private copyContracts;

    constructor(BeraCopyNFT _beraCopyNFT) {
        beraCopyNFT = _beraCopyNFT;
    }

    function isCreated(address contractAddress) public view returns (bool) {
        return copyContracts[contractAddress];
    }

    function createCopyContract() public returns (address _createdAddress, uint256 _tokenId, address _creator) {
        uint256 newTokenId = beraCopyNFT.create(msg.sender);

        BeraCopy createdContract = new BeraCopy(newTokenId, msg.sender);
        address createdAddress = address(createdContract);

        copyContracts[createdAddress] = true;

        emit CopyTradeCreated(createdAddress, msg.sender, newTokenId);

        return (createdAddress, newTokenId, msg.sender);
    }
}
