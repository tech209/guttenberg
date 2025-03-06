Guttenberg Blockchain Protocol

A decentralized protocol for registering, storing, and managing books, utilizing NFTs and tokenized words.

Overview

The Guttenberg Blockchain Protocol is a blockchain-based system designed for the registration, storage, and distribution of digital books. It leverages MasterNFTs to represent books, EditionNFTs for unique editions, and WordTokens to tokenize textual content.

Features
	•	Decentralized Book Registration: Assigns unique UUIDs to books.
	•	Master & Edition NFTs: Tracks book ownership and editions.
	•	Tokenized Word Storage: Enables on-chain word storage and retrieval.
	•	Secure Book Parsing: Ensures proper structuring of digital books.

Installation

To deploy and interact with the Guttenberg smart contracts, follow these steps:

1. Clone the Repository

git clone https://github.com/your-repo/guttenberg.git
cd guttenberg

2. Install Dependencies

Make sure you have Node.js, Hardhat, and necessary dependencies installed:

npm install

3. Compile the Smart Contracts

npx hardhat compile

4. Deploy to a Test Network

Modify your Hardhat config to set the appropriate network, then run:

npx hardhat run scripts/deploy.js --network goerli

Smart Contract Architecture

The system is built on multiple Solidity contracts:

1. Parser.sol

Handles book UUID generation and parsing.
	•	generateBookUUID(): Generates a unique identifier for a book.
	•	parseBook(): Processes book content for storage.

2. Definitions.sol

Contains essential definitions, enums, or structs used across the protocol.

3. GuttenbergRegistry.sol

Manages the registration of MasterNFTs.
	•	registerMasterNFT(): Registers a new MasterNFT.
	•	isMasterNFTRegistered(): Checks if a MasterNFT is registered.
	•	getMasterNFT(): Retrieves the details of a registered MasterNFT.

4. WordToken.sol

A fungible token contract representing words stored on-chain.
	•	mintWords(): Mints new word tokens.
	•	burnWords(): Burns word tokens.

5. EditionNFT.sol

Manages the creation and minting of book editions.
	•	createEdition(): Creates a new edition.
	•	mintEdition(): Mints an edition NFT.

6. MasterNFT.sol

Represents the primary ownership of a book.
	•	mintMasterNFT(): Mints a new MasterNFT.
	•	getMasterDetails(): Retrieves details of a MasterNFT.

7. BookStorage.sol

Handles on-chain word storage.
	•	storeWord(): Stores a word in the system.
	•	getWords(): Retrieves stored words.

8. EntryPoint.sol

The main contract for book registration and storage.
	•	registerAndUploadBook(): Registers and uploads book content.

Usage

To interact with the smart contracts, you can use Hardhat tasks, Ethers.js, or a custom frontend.

Register a Book

Example of calling the registerAndUploadBook() function:

const contract = new ethers.Contract(entryPointAddress, EntryPoint.abi, signer);
await contract.registerAndUploadBook("My Book Title", "Book Content Hash");

Mint Word Tokens

const contract = new ethers.Contract(wordTokenAddress, WordToken.abi, signer);
await contract.mintWords(signer.address, 1000);

License

This project is licensed under the GNU Affero General Public License v3.0 (AGPLv3).
You can find the full license text in the LICENSE file or at GNU’s official site.
