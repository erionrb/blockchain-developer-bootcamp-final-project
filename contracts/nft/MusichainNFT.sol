// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";

/**
 * @title Musichain NFT Contract
 * @notice The base contract to create NFTs in Musichain plataform
 */
contract MusichainNFT is ERC1155, ERC1155Burnable {
    address private _owner;
    mapping(uint256 => TokenType) private tokenTypeMap;

    struct TokenType {
        uint256 id;
        string tokenURI;
        bool mintable;
    }

    constructor(address _deployer, string memory _baseUrl) ERC1155(_baseUrl) {
        _setOwner(_deployer);
    }

    event OwnershipTransfered(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _setOwner(newOwner);
    }

    /**
     * @dev Set the owner of the contract.
     */
    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransfered(oldOwner, newOwner);
    }

    /**
     * @dev Min a new token to the contract.
     */
    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public {
        require(tokenTypeMap[id].mintable, "Token is not mintable");
        _mint(account, id, amount, data);
    }

    /**
     * @dev Transfer a token to another account(owner).
     */
    function transferFrom(
        address _from,
        address _receiver,
        uint256 _tokenId,
        uint256 _amount
    ) public {
        _safeTransferFrom(_from, _receiver, _tokenId, _amount, "");
    }

    /**
     * @dev Add new token type to the contract. (Only owner can execute this)
     */
    function addTokenType(uint256 _tokenId, string memory _tokenUri)
        public
        onlyOwner
    {
        require(!tokenTypeMap[_tokenId].mintable, "Token Type already created");
        tokenTypeMap[_tokenId] = TokenType(_tokenId, _tokenUri, true);
    }

    function getTokenUri(uint256 _tokenId) public view returns (string memory) {
        return tokenTypeMap[_tokenId].tokenURI;
    }

    function isTokenTypeMintable(uint256 _tokenId) public view returns (bool) {
        return tokenTypeMap[_tokenId].mintable;
    }
}
