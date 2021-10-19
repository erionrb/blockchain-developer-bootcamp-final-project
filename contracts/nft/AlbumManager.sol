// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

//// @title Media Album
//// @notice Create and manage albums as NFT, so users can take musics together in separeted NFT contracts.
//// @dev Could have many related NFTs as necessary, once music tracks are part of a common album.
//// Example:
//// Album:  Frank SiNFTra        (NFT Contract)
//// Track1: Fly me to the NFT    (NFT), Id (0)
//// Track2: New NFT, New NFT     (NFT), Id (1)
//// Track3: Strangers In The NFT (NFT), Id (3)
contract AlbumManager is Ownable {

    //// @notice Prevent not media owner creation 
    modifier onlyMediaOwner() {
        // TODO put here a require to skip not media owner
        _;
    }

    //// @notice Creates a new album as NFT contract.
    function mintAlbum() public {
        // TODO deploy a new MusichainNFTTemplate to represent the album
    }

    //// @notice Add media to existence album once at a time.
    //// @param _album The album address
    //// @param _id NFT id
    function mintMedia(address _album, uint256 _id) public onlyMediaOwner {
        // TODO mint a NFT to existence album
    }

    //// @notice Add media to existence album, many as needed.
    //// @param _album The album address
    //// @param _id NFT id
    //// @param _amount How many NFTs will be minted
    function mintMedia(address _album, uint256 _id, uint256 _amount) public onlyMediaOwner {
        // TODO mint some NFT to existence album
    }
}
