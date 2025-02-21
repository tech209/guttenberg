// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Definitions {
    struct Book {
        string title;
        string author;
        uint256[] editionIds;
    }

    struct Edition {
        uint256 bookId;
        uint256 minted;
        uint256 maxPrints;
        string passphrase;
    }
}
