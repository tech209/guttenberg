// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./GuttenbergRegistry.sol";

contract MasterNFT is ERC721Enumerable, Ownable {
    struct MasterPrint {
        string title;
        string author;
        uint256 totalWords;
    }

    mapping(bytes32 => MasterPrint) private masterPrints;
    GuttenbergRegistry public registry;

    event MasterNFTMinted(bytes32 indexed bookUUID, string title, string author, uint256 totalWords);

    constructor(address _registry, address _initialOwner) ERC721("MasterNFT", "MPRINT") Ownable(_initialOwner) {
        registry = GuttenbergRegistry(_registry);
    }

    function mintMasterNFT(bytes32 bookUUID, string memory title, string memory author, uint256 wordCount) external onlyOwner returns (bytes32) {
        require(!registry.isMasterNFTRegistered(bookUUID), "Master NFT already exists");

        _safeMint(msg.sender, uint256(bookUUID));  // ✅ Use UUID as token ID

        masterPrints[bookUUID] = MasterPrint({
            title: title,
            author: author,
            totalWords: wordCount
        });

        registry.registerMasterNFT(bookUUID, address(this), msg.sender); // ✅ Pass bookUUID directly

        emit MasterNFTMinted(bookUUID, title, author, wordCount);
        return bookUUID;
    }

    function getMasterDetails(bytes32 bookUUID) external view returns (string memory, string memory, uint256) {
        require(registry.isMasterNFTRegistered(bookUUID), "Master NFT not found in registry");

        MasterPrint storage master = masterPrints[bookUUID];
        return (master.title, master.author, master.totalWords);
    }
}
