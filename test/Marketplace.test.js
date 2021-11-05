const { expect } = require("chai");
const URI = "http://mycustomui.com/{id}";
const isDebugEnabled = false;
const AlbumNFT_JSON = require("../artifacts/contracts/nft/AlbumNFT.sol/AlbumNFT.json");
const MediaNFT_JSON = require("../artifacts/contracts/nft/MediaNFT.sol/MediaNFT.json");

const log = (message) => (isDebugEnabled ? console.log(message) : () => {});
const errorEvaluation = (_error, _expectedError) =>
  ("" + _error).includes(_expectedError);

describe("Marketplace", async () => {
  let marketplace;
  let album;
  let media;
  let nftOwner;
  let anotherAccount;

  // How we gonna store our tokens in the test run
  // [{
  //   owner: "0x0000000000000000000000000000000000000000",
  //   albums: [],
  //   medias: []

  // }];
  let tokens = [];

  before(async () => {
    // NFTFactory ==============================================================
    // Set the buyer address as accounts[1]
    // accounts[0] or first account is ignored as it is the owner of the contract
    const [_, _nftOwner, _anotherAccount] = await ethers.getSigners();
    nftOwner = _nftOwner;
    anotherAccount = _anotherAccount;

    NFTFactory = await ethers.getContractFactory("NFTFactory");
    // Instantiate NFT Factory
    factory = await NFTFactory.deploy();
    await factory.deployed();
    // =========================================================================

    // Marketplace =============================================================
    const Marketplace = await ethers.getContractFactory("Marketplace");
    // Instantiate Marketplace
    marketplace = await Marketplace.deploy(factory.address);
    await marketplace.deployed();

    let tx = await factory.connect(nftOwner).createAlbumNFT(URI);
    let result = await tx.wait();

    let logs = result.events.filter((e) => e.event === "AlbumCreated");
    const { __, _album } = logs[0].args;
    album = _album;
    // =========================================================================

    tx = await factory.connect(nftOwner).createMediaNFT(URI);
    result = await tx.wait();

    logs = result.events.filter((e) => e.event === "MediaCreated");
    const { ___, _media } = logs[0].args;
    media = _media;
  });

  it("[Album] Should add album", async () => {
    const sellingPrice = ethers.utils.parseUnits("10", "ether");
    let tx = await marketplace
      .connect(nftOwner)
      .addAlbumToMarket(album, sellingPrice);
    const result = await tx.wait();

    let logs = result.events.filter((e) => e.event === "NewAlbumToSales");
    const { _seller, _album } = logs[0].args;
    log(`_seller: ${_seller}\n_album: ${_album} `);

    expect(_seller).to.equal(nftOwner.address);
    expect(_album).to.not.be.undefined;
  });

  it("[Album] Should not add album twice", async () => {
    const sellingPrice = ethers.utils.parseUnits("10", "ether");
    const expectedError = "Album already exists";

    await marketplace
      .connect(nftOwner)
      .addAlbumToMarket(album, sellingPrice)
      .then(
        (result) => {},
        (error) => expect(errorEvaluation(error, expectedError)).to.equal(true)
      );
  });

  it("[Media] Should add media", async () => {
    const sellingPrice = ethers.utils.parseUnits("10", "ether");
    let tx = await marketplace
      .connect(nftOwner)
      .addMediaToMarket(media, sellingPrice);
    const result = await tx.wait();

    let logs = result.events.filter((e) => e.event === "NewMediaToSales");
    const { _seller, _media } = logs[0].args;
    log(`_seller: ${_seller}\n_album: ${_media} `);

    expect(_seller).to.equal(nftOwner.address);
    expect(_media).to.not.be.undefined;
  });

  it("[Media] Should not add media twice", async () => {
    const sellingPrice = ethers.utils.parseUnits("10", "ether");
    const expectedError = "Media already exists";

    await marketplace
      .connect(nftOwner)
      .addMediaToMarket(media, sellingPrice)
      .then(
        (result) => {},
        (error) => expect(errorEvaluation(error, expectedError)).to.equal(true)
      );
  });
});
