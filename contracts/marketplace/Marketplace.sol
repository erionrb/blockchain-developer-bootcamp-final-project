// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../nft/MusichainNFT.sol";

/**
 * @title The Musichain NFT marketplace
 * @notice Manage the marketplace for NFTs in the Musichain plataform
 */
contract Marketplace is Ownable {
    /**
     * State variables
     */

    MarketplaceItem[] private marketItems;
    MarketplaceItemToken[] private marketItemTokens;
    mapping(address => MarketplaceItem) private contractToMarketItems;
    mapping(address => MarketplaceItemToken[])
        private contractToMarketItemTokens;

    /**
     * Events
     */
    event MarketplaceTokenAdded(
        address indexed _seller,
        address _contract,
        uint256 _tokenId
    );
    event MarketplaceContractAdded(address indexed _seller, address _contract);

    /**
     * Structs
     */
    struct MarketplaceItem {
        address owner;
        address contractAddress;
        string name;
        string description;
    }

    struct MarketplaceItemToken {
        address owner;
        address seller;
        address contractAddress;
        string name;
        uint256 price;
        uint256 tokenId;
        bool sold;
    }

    /**
     * @notice Prevent non nft owners to access the function.
     */
    modifier onlyNftOwner(address _contract) {
        require(
            MusichainNFT(_contract).owner() == msg.sender,
            "Only NFT owner is allowed"
        );
        _;
    }

    /**
     * Functions
     */

    /**
     * @notice Add a contract to the marketplace.
     * @param _url The nft url for token creation.
     * @param _name The name of the contract
     * @param _description The description of the contract
     */
    function addContract(
        string memory _url,
        string memory _name,
        string memory _description
    ) public {
        MusichainNFT nftContract = new MusichainNFT(msg.sender, _url);
        MarketplaceItem memory marketplaceItem = MarketplaceItem({
            owner: msg.sender,
            contractAddress: address(nftContract),
            name: _name,
            description: _description
        });

        marketItems.push(marketplaceItem);
        contractToMarketItems[address(nftContract)] = marketplaceItem;

        emit MarketplaceContractAdded(msg.sender, address(nftContract));
    }

    /**
     * @notice Add a token to the marketplace.
     * @param _contract The address of the nft contract.
     * @param _tokenId Id of the NFT Token.
     * @param _price The price of the item.
     */
    function addToken(
        address _contract,
        string memory _name,
        uint256 _tokenId,
        uint256 _price
    ) public onlyNftOwner(_contract) {
        require(_price > 0, "Price must be greater than 0");
        require(
            contractToMarketItems[_contract].owner != address(0),
            "Contract does not exist"
        );

        // Mint a new token to the user and add it to the marketplace
        MusichainNFT(_contract).mint(msg.sender, _tokenId, 1, "");

        MarketplaceItemToken
            memory marketplaceItemToken = MarketplaceItemToken({
                owner: address(0),
                seller: address(msg.sender),
                contractAddress: _contract,
                name: _name,
                price: _price,
                tokenId: _tokenId,
                sold: false
            });

        marketItemTokens.push(marketplaceItemToken);
        contractToMarketItemTokens[_contract].push(marketplaceItemToken);

        emit MarketplaceTokenAdded(msg.sender, _contract, _tokenId);
    }

    /**
     * @notice Return sender marketplace NFT Contracts in the marketplace.
     */
    function getSellerContracts()
        public
        view
        returns (MarketplaceItem[] memory)
    {
        // Take the lenght of the array based on the number of sender contracts
        uint256 itemsLength = 0;
        for (uint256 i = 0; i < marketItems.length; i++) {
            if (marketItems[i].owner == msg.sender) {
                itemsLength++;
            }
        }

        MarketplaceItem[] memory senderItems = new MarketplaceItem[](
            itemsLength
        );
        uint256 position = 0;
        for (uint256 i = 0; i < marketItems.length; i++) {
            if (marketItems[i].owner == msg.sender) {
                senderItems[position] = marketItems[i];
                position++;
            }
        }

        // MarketplaceItem[] memory senderItems = new MarketplaceItem[](1);
        // senderItems[0] = MarketplaceItem({
        //     owner: msg.sender,
        //     contractAddress: address(this),
        //     url: "http://bananasplit.com/{id}",
        //     name: "Little Monkey Gord",
        //     description: "I wanna jump forever"
        // });
        return senderItems;
    }

    /**
     * @notice Return marketplace contract item tokens.
     */
    function getContractTokens(address _contract)
        public
        view
        returns (MarketplaceItemToken[] memory)
    {
        return contractToMarketItemTokens[_contract];
    }

    /**
     * @notice Return sold market items.
     * @return Array of sold market items.
     */
    function getSoldTokens() public view returns (MarketplaceItem[] memory) {
        // Take the lenght of the array based on not owmned tokens
        uint256 itemsLength = 0;
        for (uint256 i = 0; i < marketItems.length; i++) {
            if (marketItems[i].owner != address(0)) {
                itemsLength++;
            }
        }

        MarketplaceItem[] memory items = new MarketplaceItem[](itemsLength);
        uint256 currentPosition = 0;
        for (uint256 i = 0; i < marketItems.length; i++) {
            if (marketItems[i].owner != address(0)) {
                items[currentPosition] = marketItems[i];
                currentPosition++;
            }
        }
        return items;
    }

    /**
     * @notice Return all marketplace items of the sender.
     * @return The market items of the sender.
     */
    function getAvailableTokens()
        public
        view
        returns (MarketplaceItemToken[] memory)
    {
        uint256 itemsLength = 0;
        for (uint256 i = 0; i < marketItemTokens.length; i++) {
            if (marketItemTokens[i].owner == address(0)) {
                itemsLength++;
            }
        }

        MarketplaceItemToken[] memory items = new MarketplaceItemToken[](
            itemsLength
        );
        uint256 currentPosition = 0;
        for (uint256 i = 0; i < marketItemTokens.length; i++) {
            if (marketItemTokens[i].owner == address(0)) {
                items[currentPosition] = marketItemTokens[i];
                currentPosition++;
            }
        }
        return items;
    }

    receive() external payable {
        revert("No ether can be sent directly to this contract");
    }
}
