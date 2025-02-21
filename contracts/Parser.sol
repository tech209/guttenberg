// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MasterNFT.sol"; 
import "./BookStorage.sol";
import "./EditionNFT.sol";

contract Parser {
    MasterNFT public masterNFT;
    EditionNFT public editionNFT;
    BookStorage public bookStorage;

    event BookUUIDGenerated(bytes32 indexed bookUUID, string title, string author, string date);
    event BookParsed(bytes32 indexed bookUUID, string title);

    constructor(address _masterNFT, address _editionNFT, address _bookStorage) {
        masterNFT = MasterNFT(_masterNFT);
        editionNFT = EditionNFT(_editionNFT);
        bookStorage = BookStorage(_bookStorage);
    }

    function generateBookUUID(string memory title, string memory author, string memory date) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(title, author, date));
    }

    function parseBook(bytes32 bookUUID, string memory title) external returns (bytes32) {
        emit BookParsed(bookUUID, title);
        return bookUUID;
    }
}
