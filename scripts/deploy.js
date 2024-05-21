const hre = require("hardhat");
require("dotenv").config();

async function main() {
  const Erc20 = await hre.ethers.getContractFactory("ERC20");
  const erc20 = await Erc20.deploy(1000, "IBRIZ", "IBZ", 18);
  await erc20.waitForDeployment();
  console.log("Contract deployed at", erc20.target);
}

main()
  .then(() => {
    process.exit(0);
  })
  .catch((err) => {
    console.log(err);
    process.exit(1);
  });

//  deployed contract 0x4A1D0bf0421Cd72e6394E1d2F0C71C192D8E8B85
