// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./BeraCopyNFT.sol";
import {BeraCopy} from "./BeraCopy.sol";

contract BeraCopyFactory {
    //    event CopyTradeCreated();

    BeraCopyNFT public beraCopyNFT;

    constructor(BeraCopyNFT _beraCopyNFT) {
        beraCopyNFT = _beraCopyNFT;
    }

    function createCopyContract() public {
        uint256 tokenId = beraCopyNFT.create(msg.sender);

        new BeraCopy(tokenId, msg.sender);
    }
}
