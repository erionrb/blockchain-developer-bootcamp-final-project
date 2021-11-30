const { expect } = require("chai");
const URI = "http://mycustomui.com/{id}";
const isDebugEnabled = false;
const MusichainNFT = require("../artifacts/contracts/nft/MusichainNFT.sol/MusichainNFT.json");

const log = (message) => (isDebugEnabled ? console.log(message) : () => {});
const errorEvaluation = (_error, _expectedError) =>
  ("" + _error).includes(_expectedError);

describe("Marketplace", async () => {
  let marketplace;
  let nftOwner;
  let anotherAccount;
  let lastAlbumContractAddress;
  let lastMarketTokenId;

  before(async () => {
    // Set the buyer address as accounts[1]
    // accounts[0] or first account is ignored as it is the owner of the contract
    const [_, _nftOwner, _someAccount, _anotherAccount] =
      await ethers.getSigners();
    nftOwner = _nftOwner;
    someAccount = _someAccount;
    anotherAccount = _anotherAccount;

    // Marketplace =============================================================
    const Marketplace = await ethers.getContractFactory("Marketplace");
    // Instantiate Marketplace
    marketplace = await Marketplace.deploy();
    await marketplace.deployed();
  });

  it("[NFT Contract] Should add album to Marketplace", async () => {
    const _name = "My Album";
    const _description = "This is a test album";

    let tx = await marketplace
      .connect(someAccount)
      .addContract(URI, _name, _description);
    const result = await tx.wait();

    let logs = result.events.filter(
      (e) => e.event === "MarketplaceContractAdded"
    );
    const { _seller, _contract } = logs[0].args;
    log(`_seller: ${_seller}\n_album: ${_contract} `);

    lastAlbumContractAddress = _contract;
    expect(_seller).to.equal(someAccount.address);
    expect(_contract).to.not.be.undefined;
  });

  it("[NFT Token] Should not add media to album NFT when tokenId is unknown (not mintable)", async () => {
    const _name = "My Music";
    const _nftTokenId = 1;
    const _price = ethers.utils.parseEther("0.001");
    const expectedError = "Token Id is not Mintable";

    await marketplace
      .connect(someAccount)
      .addToken(lastAlbumContractAddress, _name, _nftTokenId, _price)
      .then(
        (result) => {},
        (error) => expect(errorEvaluation(error, expectedError)).to.equal(true)
      );
  });

  it("[NFT Token] Should add token id to NFT Contract", async () => {
    const nftContract = new ethers.Contract(
      lastAlbumContractAddress,
      MusichainNFT.abi,
      someAccount
    );

    const tokenId = 1;
    const tokenUri = "uRQdrregr77";
    const tx = await nftContract.addTokenType(tokenId, tokenUri);
    const result = await tx.wait();

    let logs = result.events.filter((e) => e.event === "TokenTypeAdded");
    const { _tokenId, _tokenUri } = logs[0].args;
    log(`_tokenId: ${_tokenId}\n_tokenUri: ${_tokenUri} `);

    expect(_tokenId.toNumber()).to.equal(tokenId);
    expect(_tokenUri).to.equal(tokenUri);
  });

  it("[NFT Token] Should add token to Marketplace", async () => {
    const _name = "My Music";
    const _nftTokenId = 1;
    const _price = ethers.utils.parseEther("0.001");

    let tx = await marketplace
      .connect(someAccount)
      .addToken(lastAlbumContractAddress, _name, _nftTokenId, _price);
    const result = await tx.wait();

    let logs = result.events.filter((e) => e.event === "MarketplaceTokenAdded");
    const { _seller, _contract, _tokenId, _marketTokenId } = logs[0].args;
    log(
      `_seller: ${_seller}\n_token: ${_contract}\n_tokenId: ${_tokenId}\n_marketTokenId: ${_marketTokenId} `
    );

    lastMarketTokenId = _marketTokenId;
    expect(_seller).to.equal(someAccount.address);
    expect(_contract).to.equal(lastAlbumContractAddress);
    expect(_tokenId).to.equal(_nftTokenId);
  });

  it("[Marketplace] Should not buy token when price does not match", async () => {
    const price = ethers.utils.parseEther("0.01");
    const expectedError = "NFT token price is not correct";

    await marketplace
      .connect(anotherAccount)
      .buyToken(lastMarketTokenId, lastAlbumContractAddress, {
        value: price,
      })
      .then(
        (result) => {},
        (error) => expect(errorEvaluation(error, expectedError)).to.equal(true)
      );
  });

  it("[Marketplace] Should buy token from marketplace", async () => {
    const price = ethers.utils.parseEther("0.001");

    let tx = await marketplace
      .connect(anotherAccount)
      .buyToken(lastMarketTokenId, lastAlbumContractAddress, {
        value: price,
      });
    const result = await tx.wait();

    let logs = result.events.filter((e) => e.event === "TokenTransfered");
    const { _currentOwner, _newOwner, _tokenId } = logs[0].args;
    log(
      `_currentOwner: ${_currentOwner}\_newOwner: ${_newOwner}\_tokenId: ${_tokenId}`
    );

    expect(_currentOwner).to.equal(someAccount.address);
    expect(_newOwner).to.equal(anotherAccount.address);
    expect(_tokenId).to.equal(1);
  });
});
