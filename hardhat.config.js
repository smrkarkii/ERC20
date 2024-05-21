require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-web3");

require("dotenv").config();
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
    sepolia: {
      url: process.env.ALCHEMY_KEY,
      accounts: [process.env.SEPOLIA_PRIVATE_KEY],
    },
  },
};
