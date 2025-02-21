// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./MasterNFT.sol";
import "./BookStorage.sol";

contract EditionNFT is ERC1155, Ownable {
    struct Edition {
        uint256 masterId;
        uint256 maxPrints;
        uint256 minted;
    }

    mapping(uint256 => Edition) public editions;
    uint256 private _editionCounter;
    MasterNFT public masterNFT;
    BookStorage public bookStorage;

    event EditionMinted(uint256 indexed masterId, uint256 indexed editionId, address indexed reader);

    constructor(address _masterNFT, address _bookStorage, address initialOwner) 
        ERC1155("https://metadata.url/{id}.json") Ownable(initialOwner) {
        masterNFT = MasterNFT(_masterNFT);
        bookStorage = BookStorage(_bookStorage);
    }

    function createEdition(uint256 masterId, uint256 maxPrints) external onlyOwner returns (uint256) {
        require(masterNFT.ownerOf(masterId) != address(0), "Master NFT does not exist");

        uint256 editionId = ++_editionCounter;
        editions[editionId] = Edition(masterId, maxPrints, 0);

        return editionId;
    }

    function mintEdition(uint256 editionId) external {
        require(editions[editionId].minted < editions[editionId].maxPrints, "Edition sold out");

        editions[editionId].minted++;
        _mint(msg.sender, editionId, 1, "");

        emit EditionMinted(editions[editionId].masterId, editionId, msg.sender);
    }
}
