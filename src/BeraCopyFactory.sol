// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./BeraCopyNFT.sol";
import {BeraCopy} from "./BeraCopy.sol";
import {Ownable} from "../dependencies/@openzeppelin-contracts-5.0.2/access/Ownable.sol";

contract BeraCopyFactory is Ownable {
    event CopyTradeCreated(address indexed createdAddress, address indexed target, uint256 indexed tokenId);

    BeraCopyNFT public beraCopyNFT;
    mapping(address => bool) private copyContracts;

    constructor(BeraCopyNFT _beraCopyNFT, address initialOwner) Ownable(initialOwner) {
        beraCopyNFT = _beraCopyNFT;
    }

    function isCreated(address contractAddress) public view returns (bool) {
        return copyContracts[contractAddress];
    }

    function createCopyContract(address _copyTarget)
        public
        returns (address _createdAddress, uint256 _tokenId, address _creator, address _target)
    {
        uint256 newTokenId = beraCopyNFT.create(msg.sender);

        BeraCopy createdContract = new BeraCopy(newTokenId, owner(), _copyTarget, beraCopyNFT);
        address createdAddress = address(createdContract);

        copyContracts[createdAddress] = true;

        emit CopyTradeCreated(createdAddress, _copyTarget, newTokenId);

        return (createdAddress, newTokenId, msg.sender, _copyTarget);
    }
}
