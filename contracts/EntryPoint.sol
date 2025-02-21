// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./GuttenbergRegistry.sol";
import "./MasterNFT.sol";
import "./EditionNFT.sol";
import "./Parser.sol";
import "./BookStorage.sol";

contract EntryPoint {
    GuttenbergRegistry public registry;
    MasterNFT public masterNFT;
    EditionNFT public editionNFT;
    Parser public parser;
    BookStorage public bookStorage;

    event BookProcessed(bytes32 indexed bookUUID, string title, address indexed author, uint256 editionId);

    constructor(address _registry, address _masterNFT, address _editionNFT, address _parser, address _bookStorage) {
        registry = GuttenbergRegistry(_registry);
        masterNFT = MasterNFT(_masterNFT);
        editionNFT = EditionNFT(_editionNFT);
        parser = Parser(_parser);
        bookStorage = BookStorage(_bookStorage);
    }

    function registerAndUploadBook(
        string memory title,
        string memory author,
        string memory date,
        string[] memory words
    ) external {
        // 1️⃣ Generate a Unique Book UUID
        bytes32 bookUUID = parser.generateBookUUID(title, author, date);
        
        // 2️⃣ Check if the book already exists
        if (!registry.isMasterNFTRegistered(bookUUID)) {
            // 3️⃣ If not, mint a Master NFT and register it
            bytes32 masterUUID = masterNFT.mintMasterNFT(bookUUID, title, author, words.length);
            registry.registerMasterNFT(masterUUID, address(masterNFT), msg.sender);
        }

        // 4️⃣ Store words in BookStorage
        for (uint256 i = 0; i < words.length; i++) {
            bookStorage.storeWord(bookUUID, i, words[i]); 
        }

        // 5️⃣ Create an Edition NFT
        uint256 editionId = editionNFT.createEdition(uint256(bookUUID), 100);

        // 6️⃣ Emit Event
        emit BookProcessed(bookUUID, title, msg.sender, editionId);
    }
}
