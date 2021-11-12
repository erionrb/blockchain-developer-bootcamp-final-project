const hre = require("hardhat");

async function main() {
  const NFTFactory = await hre.ethers.getContractFactory("NFTFactory");
  nftFactory = await NFTFactory.deploy();
  await nftFactory.deployed();
  console.log("NFTFactory deployed to:", nftFactory.address);

  const Marketplace = await hre.ethers.getContractFactory("Marketplace");
  marketplace = await Marketplace.deploy(nftFactory.address);
  await marketplace.deployed();
  console.log("Marketplace deployed to:", marketplace.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
