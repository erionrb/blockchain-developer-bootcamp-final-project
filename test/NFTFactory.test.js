const { expect } = require("chai");
const URI = "http://mycustomui.com/{id}";

describe("NFTFactory", async () => {
  it("Should create Album NFT", async () => {
    let nftAlbumAddress;
    // Set the buyer address as accounts[1]
    // accounts[0] or first account is ignored as it is the owner of the contract
    const [_, nftOwner] = await ethers.getSigners();
    const NFTFactory = await ethers.getContractFactory("NFTFactory");

    // Instantiate NFT Factory
    const factory = await NFTFactory.deploy();
    await factory.deployed();

    let tx = await factory.connect(nftOwner).createAlbumNFT(URI);
    const res = await tx.wait();

    let logs = res.events.filter((e) => e.event === "AlbumCreated");
    const { _owner, _album } = logs[0].args;
    //console.log(`_owner: ${_owner}`);
    //console.log(`_album: ${_album}`);

    expect(_owner).to.equal(nftOwner.address);
    expect(_album).to.not.be.undefined;
  });
});
