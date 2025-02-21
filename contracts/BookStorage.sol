// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BookStorage {
    struct Word {
        bytes32 bookUUID;
        uint256 index;
        string content;
    }

    mapping(bytes32 => Word[]) private bookWords;

    event WordStored(bytes32 indexed bookUUID, uint256 index, string content);

    function storeWord(bytes32 bookUUID, uint256 index, string memory content) external {
        bookWords[bookUUID].push(Word(bookUUID, index, content)); // ✅ Ensure proper semicolon
        emit WordStored(bookUUID, index, content);
    }

    function getWords(bytes32 bookUUID) external view returns (Word[] memory) {
        return bookWords[bookUUID];
    }
}
