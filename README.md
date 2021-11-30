# Blockchain Developer Bootcamp Final Project

Bootcamp URL: https://courses.consensys.net/courses/blockchain-developer-bootcamp-registration-2021

### My Ethereum Address for certification: 0x4c49f31e2AcEBa16be8ec50C8bfA7556CFCa2a03

## What does the project do?

The project is a decentralized music store where anyone can publish his music and earn royalties for every sell. With a marketplace smart contract that serve the NFT Music Album Contract Owner, to publish his musics as NFT tokens and sell them to other users in the network.

## Deployed contract

To access the Musichain marketplace and test the interaction with the smart contract read the instructions bellow.

- The contract has been deployed to the [Binance testnet](https://testnet.binance.org): 0x4512a4567b2716d5D040dA0d654089d598e5d7Db.
- The owner account of deployed contract is: 0x4c49f31e2AcEBa16be8ec50C8bfA7556CFCa2a03.

## How to test
Open a terminal a terminal and execute the following commands bellow in the root of the of the project (make sure to do the same sequence):
```
npx hardhat node
npx hardhat test
```

## Next Steps

- Enable cooparticipation royalties for NFT selling.
- Optimize the UI for better user experience.

## Sell a NFT Music in Marketplace Workflow

1. Access the Marketplace website if you haven't already done so.
2. Click on Album link in the marketplace menu
3. If you want click on "Mock" button for fast filling the form
4. Click on "Create" to deploy your NFT Album Contract, it will call metamask if you have not already done so.
5. Once ou have the metamask request confirmation click on "My Dashboard"
6. Click on "Add NFT"
7. Click on "Create Token Id", it is a requirement to any new type of NFT. This will be used as your NFT Id.
8. Fill the form with the information of your Music NFT, make sure that you wait until receive the confirmation of the music has beed uploaded.
9. Click on "Create NFT Type" and take back to the previous screen.
10. At this point your going to be able to fill your NFT info and mint it with your price. For it click on button "Mint NFT".
11. After it's completion click on "Marketplace" menu and find for your NFT, it should be listed and available for others to buy.

## Buy a NFT Music in Marketplace Workflow

1. Access the Marketplace website if you haven't already done so.
2. Click on "Marketplace" menu amd find for an NFT with the button buy available.
3. Click on "Buy" and accept the metamask request.
4. Once it is accepted you can refresh the website and see the NFT in the marketplace with a button to pĺay the music there, you can change the filter to "Owned" for easy access if you want.

## Accessing the frontend

You can access the frontend [here](https://blockchain-developer-bootcamp-final-project-rho.vercel.app/).

## Screencast

To view a screencast [visit](https://www.loom.com/share/f699e80ba68b424c965fd6a6ec90d7ad)

:warning: **Make sure you are connecting a BSC testnet wallet**: Be very careful here!

## Getting started
**Make sure that you have installed hardhat globally with npm install -g hardhat before you proceed with this**

To install the local dependencies run `yarn install` in the `root` directory of the project. To run the frontend, call `yarn run serve` also in the root directory.

To run the contract tests, run `npx hardhat node` and `npx hardhat test` in the root directory.

## Directory Structure

The contract code, the associated infrastructure and the frontend can be found in the `root` of the repo.

Inspired by [OpenZepellin Contracts Wizard](https://wizard.openzeppelin.com/) and [Remix Ethereum IDE](https://remix.ethereum.org/)
