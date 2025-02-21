// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MasterNFT.sol";
import "./EditionNFT.sol";
import "./WordToken.sol";

contract GuttenbergRegistry {
    struct RegisteredBook {
        bytes32 bookUUID;
        address masterContract;
        address editionContract;
        address author;
    }

    mapping(bytes32 => RegisteredBook) public books;
    mapping(bytes32 => address) public registeredMasterNFTs;
    WordToken public wordToken;
    EditionNFT public editionNFT;

    event MasterNFTRegistered(bytes32 indexed bookUUID, address indexed masterContract);
    event BookRegistered(bytes32 indexed bookUUID, address indexed masterContract, address indexed editionContract);
    event EditionMinted(bytes32 indexed bookUUID, uint256 indexed editionId, address reader);

    constructor(address _wordToken, address _editionNFT) {
        wordToken = WordToken(_wordToken);
        editionNFT = EditionNFT(_editionNFT);
    }

    function registerMasterNFT(bytes32 bookUUID, address masterContract, address owner) external {
        require(registeredMasterNFTs[bookUUID] == address(0), "Master NFT already registered");
        registeredMasterNFTs[bookUUID] = masterContract;
        books[bookUUID] = RegisteredBook(bookUUID, masterContract, address(editionNFT), owner);
        emit MasterNFTRegistered(bookUUID, masterContract);
    }

    function isMasterNFTRegistered(bytes32 bookUUID) external view returns (bool) {
        return registeredMasterNFTs[bookUUID] != address(0);
    }

    function getMasterNFT(bytes32 bookUUID) external view returns (address) {
        require(registeredMasterNFTs[bookUUID] != address(0), "Master NFT not registered");
        return registeredMasterNFTs[bookUUID];
    }
}
