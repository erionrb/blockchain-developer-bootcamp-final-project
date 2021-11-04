const { expect } = require("chai");
const URI = "http://mycustomui.com/{id}";
const isDebugEnabled = false;
const AlbumNFT_JSON = require("../artifacts/contracts/nft/AlbumNFT.sol/AlbumNFT.json");
const MediaNFT_JSON = require("../artifacts/contracts/nft/MediaNFT.sol/MediaNFT.json");

const log = (message) => (isDebugEnabled ? console.log(message) : () => {});

describe("NFTFactory", async () => {
  let factory;
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
    // Set the buyer address as accounts[1]
    // accounts[0] or first account is ignored as it is the owner of the contract
    const [_, _nftOwner, _anotherAccount] = await ethers.getSigners();
    nftOwner = _nftOwner;
    anotherAccount = _anotherAccount;
    NFTFactory = await ethers.getContractFactory("NFTFactory");
    // Instantiate NFT Factory
    factory = await NFTFactory.deploy();
    await factory.deployed();
  });

  // -------------------------------------------------------------------//
  // AlbumNFT tests ----------------------------------------------------//
  // -------------------------------------------------------------------//
  it("(AlbumNFT) Should create album NFT", async () => {
    let tx = await factory.connect(nftOwner).createAlbumNFT(URI);
    const result = await tx.wait();

    let logs = result.events.filter((e) => e.event === "AlbumCreated");
    const { _owner, _album } = logs[0].args;
    log(`_owner: ${_owner}\n_album: ${_album} `);

    tokens[_owner] = { owner: _owner, albums: [], medias: [] };
    tokens[_owner].albums.push(_album);

    expect(_owner).to.equal(nftOwner.address);
    expect(_album).to.not.be.undefined;
  });

  it("(AlbumNFT) Should add media to album NFT", async () => {
    const tokenId = 1; // Track 1 => Black Magic Crypto
    const albumAddress = tokens[nftOwner.address].albums[0];
    let tx = await factory
      .connect(nftOwner)
      .createAlbumToken(albumAddress, tokenId);
    const result = await tx.wait();

    let logs = result.events.filter((e) => e.event === "AlbumTokenMinted");
    const { _owner, _album, _tokenId } = logs[0].args;
    log(`_owner: ${_owner}\n_album: ${_album}\n_tokenId: ${_tokenId}`);

    expect(_owner).to.equal(nftOwner.address);
    expect(_album).to.not.be.undefined;
    expect(_tokenId).to.equal(1);
  });

  it("(AlbumNFT) Should not add media to album NFT when not the owner", async () => {
    const tokenId = 2; // Track 2 => Barracuda's crypto
    const albumAddress = tokens[nftOwner.address].albums[0];
    const expectedError = "Only NFT owner is acceptable";
    const errorEvaluation = (error) => ("" + error).includes(expectedError);
    await factory
      .connect(anotherAccount)
      .createAlbumToken(albumAddress, tokenId)
      .then(
        (result) => {},
        (error) => expect(errorEvaluation(error)).to.equal(true)
      );
  });

  it("(AlbumNFT) Should validate user's balance", async () => {
    const tokenId = 1; // Track 1 => Black Magic Crypto
    const albumAddress = tokens[nftOwner.address].albums[0];

    let AlbumNFTContract = new ethers.Contract(
      albumAddress,
      AlbumNFT_JSON.abi,
      nftOwner
    );

    const balance = await AlbumNFTContract.connect(nftOwner).balanceOf(
      nftOwner.address,
      tokenId
    );

    expect(balance).to.equal(1);
  });

  // -------------------------------------------------------------------//
  // MediaNFT tests ----------------------------------------------------//
  // -------------------------------------------------------------------//
  it("(MediaNFT) Should create media NFT", async () => {
    let tx = await factory.connect(nftOwner).createMediaNFT(URI);
    const result = await tx.wait();

    let logs = result.events.filter((e) => e.event === "MediaCreated");
    const { _owner, _media } = logs[0].args;
    log(`_owner: ${_owner}\n_media: ${_media} `);

    tokens[_owner].medias.push(_media);

    expect(_owner).to.equal(nftOwner.address);
    expect(_media).to.not.be.undefined;
  });

  it("(MediaNFT) Should add individual media NFT", async () => {
    const tokenId = 1; // Track 1 => Black Magic Crypto
    const mediaAddress = tokens[nftOwner.address].medias[0];
    let tx = await factory
      .connect(nftOwner)
      .createMediaToken(mediaAddress, tokenId);
    const result = await tx.wait();

    let logs = result.events.filter((e) => e.event === "MediaTokenMinted");
    const { _owner, _media, _tokenId } = logs[0].args;
    log(`_owner: ${_owner}\n_media: ${_media}\n_tokenId: ${_tokenId}`);

    expect(_owner).to.equal(nftOwner.address);
    expect(_media).to.not.be.undefined;
    expect(_tokenId).to.equal(1);
  });

  it("(MediaNFT) Should not add media NFT when not the owner", async () => {
    const tokenId = 2; // Track 2 => Barracuda's crypto
    const albumAddress = tokens[nftOwner.address].albums[0];
    const expectedError = "Only NFT owner is acceptable";
    const errorEvaluation = (error) => ("" + error).includes(expectedError);
    await factory
      .connect(anotherAccount)
      .createMediaToken(albumAddress, tokenId)
      .then(
        (result) => {},
        (error) => expect(errorEvaluation(error)).to.equal(true)
      );
  });

  it("(MediaNFT) Should validate user's balance", async () => {
    const tokenId = 1; // Track 1 => Black Magic Crypto
    const albumAddress = tokens[nftOwner.address].albums[0];

    let MediaNFTContract = new ethers.Contract(
      albumAddress,
      MediaNFT_JSON.abi,
      nftOwner
    );

    const balance = await MediaNFTContract.connect(nftOwner).balanceOf(
      nftOwner.address,
      tokenId
    );

    expect(balance).to.equal(1);
  });
});
