const hre = require("hardhat");
const fs = require("fs");

async function main() {
    console.log("🚀 Deploying Guttenberg L1 Smart Contracts...");

    // Get deployer address
    const [deployer] = await hre.ethers.getSigners();
    console.log(`Using deployer address: ${deployer.address}`);

    // Deploy WordToken (Ensure proper await syntax)
    console.log("Deploying WordToken...");
    const WordToken = await hre.ethers.getContractFactory("WordToken");
    const wordToken = await WordToken.deploy(deployer.address); // ✅ Pass initialOwner
    await wordToken.waitForDeployment(); // ✅ Fix: Use `waitForDeployment()`
    console.log(`✅ WordToken deployed to: ${await wordToken.getAddress()}`);

    // Deploy EditionNFT
    console.log("Deploying EditionNFT...");
    const EditionNFT = await hre.ethers.getContractFactory("EditionNFT");
    const editionNFT = await EditionNFT.deploy(await wordToken.getAddress(), deployer.address);
    await editionNFT.waitForDeployment();
    console.log(`✅ EditionNFT deployed to: ${await editionNFT.getAddress()}`);

    // Deploy GuttenbergRegistry
    console.log("Deploying GuttenbergRegistry...");
    const GuttenbergRegistry = await hre.ethers.getContractFactory("GuttenbergRegistry");
    const registry = await GuttenbergRegistry.deploy(await wordToken.getAddress(), await editionNFT.getAddress());
    await registry.waitForDeployment();
    console.log(`✅ GuttenbergRegistry deployed to: ${await registry.getAddress()}`);

    // Deploy MasterNFT
    console.log("Deploying MasterNFT...");
    const MasterNFT = await hre.ethers.getContractFactory("MasterNFT");
    const masterNFT = await MasterNFT.deploy(await registry.getAddress());
    await masterNFT.waitForDeployment();
    console.log(`✅ MasterNFT deployed to: ${await masterNFT.getAddress()}`);

    // Deploy Parser
    console.log("Deploying Parser...");
    const Parser = await hre.ethers.getContractFactory("Parser");
    const parser = await Parser.deploy(await masterNFT.getAddress(), await editionNFT.getAddress(), await registry.getAddress());
    await parser.waitForDeployment();
    console.log(`✅ Parser deployed to: ${await parser.getAddress()}`);

    // Deploy BookStorage
    console.log("Deploying BookStorage...");
    const BookStorage = await hre.ethers.getContractFactory("BookStorage");
    const bookStorage = await BookStorage.deploy();
    await bookStorage.waitForDeployment();
    console.log(`✅ BookStorage deployed to: ${await bookStorage.getAddress()}`);

    // Deploy EntryPoint
    console.log("Deploying EntryPoint...");
    const EntryPoint = await hre.ethers.getContractFactory("EntryPoint");
    const entryPoint = await EntryPoint.deploy(
        await registry.getAddress(),
        await masterNFT.getAddress(),
        await editionNFT.getAddress(),
        await parser.getAddress(),
        await bookStorage.getAddress()
    );
    await entryPoint.waitForDeployment();
    console.log(`✅ EntryPoint deployed to: ${await entryPoint.getAddress()}`);

    // Save contract addresses for frontend use
    const addresses = {
        WordToken: await wordToken.getAddress(),
        EditionNFT: await editionNFT.getAddress(),
        GuttenbergRegistry: await registry.getAddress(),
        MasterNFT: await masterNFT.getAddress(),
        Parser: await parser.getAddress(),
        BookStorage: await bookStorage.getAddress(),
        EntryPoint: await entryPoint.getAddress(),
    };

    fs.writeFileSync("deployed_contracts.json", JSON.stringify(addresses, null, 2));
    console.log("✅ Contract addresses saved to deployed_contracts.json");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error("❌ Deployment failed:", error);
        process.exit(1);
    });
