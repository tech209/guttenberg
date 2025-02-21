require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: {
    version: "0.8.20", // ✅ Ensure Solidity matches your fork version
    settings: {
      optimizer: { enabled: true, runs: 200 },
      evmVersion: "constantinople", // ✅ Use "constantinople" to enable shr but avoid shl
    },
  },
  networks: {
    guttenberg: {
      url: "http://3.144.13.164:8545",
      accounts: process.env.PRIVATE_KEY ? [`0x${process.env.PRIVATE_KEY}`] : [],
    },
  },
};
