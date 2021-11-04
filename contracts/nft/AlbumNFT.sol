// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MusichainNFT.sol";

//// @title Album NFT Contract
//// @notice The base contract to create Album NFTs in Musichain plataform
contract AlbumNFT is MusichainNFT {
    constructor(address _owner, string memory _baseUrl) ERC1155(_baseUrl) {
        transferOwnership(_owner);
    }

    //// @notice Checks if NFT is an album
    //// @returns True if NFT is an album, false otherwise
    function isAlbum() public pure override returns (bool) {
        return true;
    }
}
