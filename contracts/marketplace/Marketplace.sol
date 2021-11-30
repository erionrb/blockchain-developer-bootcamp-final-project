// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../nft/MusichainNFT.sol";

/**
 * @title The Musichain NFT marketplace
 * @notice Manage the marketplace for NFTs in the Musichain plataform
 */
contract Marketplace is Ownable {
    /**
     * State variables
     */
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    address[] public contractAddresses;
    mapping(address => MarketplaceItem) private contractToMarketItems;
    mapping(address => MarketplaceItemToken[])
        private contractToMarketItemTokens;

    /**
     * Events
     */
    event MarketplaceTokenAdded(
        address indexed _seller,
        address _contract,
        uint256 _tokenId,
        uint256 _marketTokenId
    );
    event MarketplaceContractAdded(address indexed _seller, address _contract);
    event TokenTransfered(
        address _currentOwner,
        address _newOwner,
        uint256 _tokenId
    );

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
        uint256 marketTokenId;
        string contractUri;
        string tokenUri;
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

        contractAddresses.push(address(nftContract));
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
        // Mint a new token to the user and add it to the marketplace
        MusichainNFT nft = MusichainNFT(_contract);
        require(_price > 0, "Price must be greater than 0");
        require(
            contractToMarketItems[_contract].owner != address(0),
            "Contract does not exist"
        );
        require(nft.isTokenTypeMintable(_tokenId), "Token Id is not Mintable");

        nft.mint(msg.sender, _tokenId, 1, "");
        _tokenIds.increment();
        uint256 _marketTokenId = _tokenIds.current();

        MarketplaceItemToken
            memory marketplaceItemToken = MarketplaceItemToken({
                owner: address(0),
                seller: msg.sender,
                contractAddress: _contract,
                name: _name,
                price: _price,
                tokenId: _tokenId,
                marketTokenId: _marketTokenId,
                contractUri: nft.uri(_tokenId),
                tokenUri: nft.getTokenUri(_tokenId),
                sold: false
            });

        contractToMarketItemTokens[_contract].push(marketplaceItemToken);

        emit MarketplaceTokenAdded(msg.sender, _contract, _tokenId, _marketTokenId);
    }

    /**
     * @notice Return sender marketplace NFT Contracts in the marketplace.
     */
    function getSellerContracts()
        public
        view
        returns (MarketplaceItem[] memory)
    {
        uint256 itemsLength = 0;
        for (uint256 i = 0; i < contractAddresses.length; i++) {
            address _contractAddress = contractAddresses[i];
            if (contractToMarketItems[_contractAddress].owner == msg.sender) {
                itemsLength++;
            }
        }

        MarketplaceItem[] memory senderItems = new MarketplaceItem[](
            itemsLength
        );
        uint256 position = 0;
        for (uint256 i = 0; i < contractAddresses.length; i++) {
            address _contractAddress = contractAddresses[i];
            if (contractToMarketItems[_contractAddress].owner == msg.sender) {
                senderItems[position] = contractToMarketItems[_contractAddress];
                position++;
            }
        }

        return senderItems;
    }

    /**
     * @notice Return marketplace NFT Contract "Tokens" in the marketplace.
     */
    function getContractTokens(address _contract)
        public
        view
        returns (MarketplaceItemToken[] memory)
    {
        return contractToMarketItemTokens[_contract];
    }

    /**
     * @notice Return marketplace contract item tokens.
     */
    function getNotSenderTokens()
        public
        view
        returns (MarketplaceItemToken[] memory)
    {
        uint256 responseLength = 0;
        // Iterate over all contracts and collect the array size
        for (uint256 i = 0; i < contractAddresses.length; i++) {
            address _contractAddress = contractAddresses[i];

            if (contractToMarketItems[_contractAddress].owner != msg.sender) {
                responseLength += contractToMarketItemTokens[_contractAddress]
                    .length;
            }
        }

        // Response array has the size of all the tokens
        MarketplaceItemToken[] memory response = new MarketplaceItemToken[](
            responseLength
        );

        uint256 tokenIndex = 0;
        // Iterate over all contracts and add the tokens into the response array
        for (uint256 i = 0; i < contractAddresses.length; i++) {
            address _contract = contractAddresses[i];

            if (contractToMarketItems[_contract].owner != msg.sender) {
                MarketplaceItemToken[]
                    memory _tokens = contractToMarketItemTokens[_contract];
                // Should add _tokens into tokens array
                for (uint256 j = 0; j < _tokens.length; j++) {
                    response[tokenIndex] = _tokens[j];
                    tokenIndex++;
                }
            }
        }

        return response;
    }

    /**
     * @notice Return marketplace contract item tokens of the sender.
     */
    function getSenderTokens()
        public
        view
        returns (MarketplaceItemToken[] memory)
    {
        uint256 responseLength = 0;
        // Iterate over all contracts and collect the array size
        for (uint256 i = 0; i < contractAddresses.length; i++) {
            address _contractAddress = contractAddresses[i];

            if (contractToMarketItems[_contractAddress].owner == msg.sender) {
                responseLength += contractToMarketItemTokens[_contractAddress]
                    .length;
            }
        }

        // Response array has the size of all the tokens
        MarketplaceItemToken[] memory response = new MarketplaceItemToken[](
            responseLength
        );

        uint256 tokenIndex = 0;
        // Iterate over all contracts and add the tokens into the response array
        for (uint256 i = 0; i < contractAddresses.length; i++) {
            address _contract = contractAddresses[i];

            if (contractToMarketItems[_contract].owner == msg.sender) {
                MarketplaceItemToken[]
                    memory _tokens = contractToMarketItemTokens[_contract];
                // Should add _tokens into tokens array
                for (uint256 j = 0; j < _tokens.length; j++) {
                    response[tokenIndex] = _tokens[j];
                    tokenIndex++;
                }
            }
        }

        return response;
    }

    /**
     * @notice Return marketplace contract item tokens of the sender.
     */
    function getTokens() public view returns (MarketplaceItemToken[] memory) {
        uint256 responseLength = 0;
        // Iterate over all contracts and collect the array size
        for (uint256 i = 0; i < contractAddresses.length; i++) {
            address _contractAddress = contractAddresses[i];

            responseLength += contractToMarketItemTokens[_contractAddress]
                .length;
        }

        // Response array has the size of all the tokens
        MarketplaceItemToken[] memory response = new MarketplaceItemToken[](
            responseLength
        );

        uint256 tokenIndex = 0;
        // Iterate over all contracts and add the tokens into the response array
        for (uint256 i = 0; i < contractAddresses.length; i++) {
            address _contract = contractAddresses[i];

            MarketplaceItemToken[] memory _tokens = contractToMarketItemTokens[
                _contract
            ];
            // Should add _tokens into tokens array
            for (uint256 j = 0; j < _tokens.length; j++) {
                response[tokenIndex] = _tokens[j];
                tokenIndex++;
            }
        }

        return response;
    }

    /**
     * @notice Buy marketplace token.
     * @param _marketTokenId Id of the Marketplace Token.
     * @param _contract The address of the nft contract.
     */
    function buyToken(uint256 _marketTokenId, address _contract)
        public
        payable
    {
        uint256 index = getMarketToken(_marketTokenId, _contract);
        MarketplaceItemToken storage token = contractToMarketItemTokens[
            _contract
        ][index];

        require(
            token.marketTokenId == _marketTokenId,
            "Market Token Id does not found"
        );
        require(token.owner == address(0), "Token is already owned");

        address currentOwner = token.seller;
        uint256 currentPrice = token.price;
        MusichainNFT nft = MusichainNFT(_contract);

        require(
            nft.balanceOf(currentOwner, token.tokenId) > 0,
            "Current owner does not have more tokens"
        );
        require(msg.value == currentPrice, "NFT token price is not correct");

        // Transfer the token to the buyer
        token.owner = msg.sender;
        token.sold = true;
        
        nft.transferFrom(currentOwner, msg.sender, token.tokenId, 1);
        (bool success, ) = token.seller.call{value: token.price}("");
        require(success, "NFT price transfer failed");

        emit TokenTransfered(currentOwner, msg.sender, token.tokenId);
    }

    function getMarketToken(uint256 _marketTokenId, address _contracty)
        private
        view
        returns (uint256)
    {
        MarketplaceItemToken[] memory items = contractToMarketItemTokens[
            _contracty
        ];
        for (uint256 i = 0; i < items.length; i++) {
            if (items[i].marketTokenId == _marketTokenId) {
                return i;
            }
        }
        return 0;
    }

    receive() external payable {
        revert("No ether can be sent directly to this contract");
    }
}
