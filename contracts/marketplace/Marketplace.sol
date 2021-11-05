// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../nft/NFTFactory.sol";
import "../nft/MusichainNFT.sol";

//// @title The Musichain NFT marketplace
//// @notice Manage the marketplace for NFTs in the Musichain plataform
contract Marketplace is Ownable {
    /**
     * State variables
     */

    // The NFT factory
    NFTFactory public nftFactory;

    mapping(address => MarketItem[]) public sellerToAlbum;
    mapping(address => MarketItem[]) public sellerToMedia;

    constructor(address _nftFactory) {
        nftFactory = NFTFactory(_nftFactory);
    }

    /**
     * Modifiers
     */

    //// @notice Prevent non nft owners to access the function.
    modifier onlyNftOwner(address _nft) {
        require(
            nftFactory.isOwner(msg.sender, _nft),
            "Only NFT owner is allowed"
        );
        _;
    }

    //// @notice Check if the nft is an album.
    modifier onlyAlbum(address _album) {
        require(MusichainNFT(_album).isAlbum(), "It is not a valid album");
        _;
    }

    //// @notice Check if the nft is a media.
    modifier onlyMedia(address _media) {
        require(!MusichainNFT(_media).isAlbum(), "It is not a valid media");
        _;
    }

    //// @notice Check if the nft was not added to market.
    modifier onlyNewNft(
        address _nft,
        MarketItem[] memory _items,
        string memory _message
    ) {
        require(!nftExists(sellerToAlbum[msg.sender], _nft), _message);
        _;
    }

    /**
     * Events
     */
    event NewAlbumToSales(address indexed _seller, address _album);
    event NewMediaToSales(address indexed _seller, address _media);

    /**
     * Structs
     */

    struct MarketItem {
        address owner;
        address nftAddress;
        uint256 price;
        bool isAlbum;
    }

    /**
     * Functions
     */

    //// @notice Add an album to the marketplace.
    /// @param _album The address of the nft album.
    /// @param _price The price of the album.
    function addAlbumToMarket(address _album, uint256 _price)
        public
        onlyNftOwner(_album)
        onlyAlbum(_album)
        onlyNewNft(_album, sellerToAlbum[msg.sender], "Album already exists")
    {
        require(_price > 0, "Price must be greater than 0");
        sellerToAlbum[msg.sender].push(
            MarketItem(msg.sender, _album, _price, true)
        );
        emit NewAlbumToSales(msg.sender, _album);
    }

    /// @notice Add a media to the marketplace.
    /// @param _media The address of the media nft.
    /// @param _price The price of the media.
    function addMediaToMarket(address _media, uint256 _price)
        public
        onlyNftOwner(_media)
        onlyMedia(_media)
        onlyNewNft(_media, sellerToMedia[msg.sender], "Media already exists")
    {
        require(_price > 0, "Price must be greater than 0");
        sellerToMedia[msg.sender].push(
            MarketItem(msg.sender, _media, _price, false)
        );
        emit NewMediaToSales(msg.sender, _media);
    }

    //// @notice Check if the nft was added to market.
    /// @return true if the nft was added to market, false otherwise.
    function nftExists(MarketItem[] memory _items, address _nft)
        private
        pure
        returns (bool)
    {
        for (uint256 i = 0; i < _items.length; i++) {
            if (_items[i].nftAddress == _nft) {
                return true;
            }
        }
        return false;
    }

    receive() external payable {
        revert("No ether can be sent directly to this contract");
    }
}
