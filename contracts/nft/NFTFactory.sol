// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AlbumNFT.sol";
import "./MediaNFT.sol";

//// @title NFT Factory
//// @notice Create and manage albums and media as NFT, so users can take musics together in separeted NFT contracts.
contract NFTFactory {
    /**
     * State Variables
     */

    mapping(address => address) public albumToOwner;
    mapping(address => address) public mediaToOwner;
    address[] public albumContracts;
    address[] public mediaContracts;

    /**
     * Modifiers
     */

    //// @notice Prevent not media owner creation
    modifier onlyMediaOwner(address _owner, address _album) {
        require(
            MediaNFT(_album).owner() == _owner,
            "Only media owner is acceptable"
        );
        _;
    }

    /**
     * Events
     */

    event AlbumCreated(address indexed _owner, address _album);
    event MediaCreated(address indexed _owner, address _media);

    /**
     * Functions
     */

    //// @notice Create new NFT album contract.
    //// @param _baseUrl The album NFT base url.
    function createAlbumNFT(string memory _baseUrl) public {
        AlbumNFT album = new AlbumNFT(msg.sender, _baseUrl);
        albumToOwner[address(album)] = msg.sender;
        emit AlbumCreated(msg.sender, address(album));
    }

    //// @notice Create NFT media contract.
    //// @param _baseUrl The media NFT base url.
    function createMediaNFT(string memory _baseUrl) public {
        MediaNFT media = new MediaNFT(msg.sender, _baseUrl);
        albumToOwner[address(media)] = msg.sender;
        emit MediaCreated(msg.sender, address(media));
    }

    //// @notice Check if the address has the ownership of the nft
    //// @param _owner The address to check ownership.
    //// @param _nft The NFT contract address.
    //// @return True if the address is the owner of the NFT.
    function isOwner(address _owner, address _nft) public view returns (bool) {
        return albumToOwner[_nft] == _owner || mediaToOwner[_nft] == _owner;
    }
}
