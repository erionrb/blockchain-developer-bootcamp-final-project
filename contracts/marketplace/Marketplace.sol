// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

//// @title The Musichain NFT marketplace
//// @notice Manage the marketplace for NFTs in the Musichain plataform
contract Marketplace is Ownable {

    /**
     * State variables
     */
    //// TODO keep track of the marketplace NFTs here

    /**
     * Modifiers
     */
    //// TODO Some modifiers will be needed, place them here

    /**
     * Functions
     */
    //// @notice Creates a new NFT as media to marketplace.
    //// @param _id NFT id
    //// @param _amount How many NFTs will be minted
    //// @param _unitPrice How much is the NFT media
    function createMedia(
        uint256 _id,
        uint256 _amount,
        uint256 _unitPrice
    ) public onlyOwner {
        // TODO create a NFT as media here
    }

    //// @notice Sell a NFT media to the buyer.
    //// @param _id NFT id
    //// @param _amount How many NFTs will be minted
    function buyMedia(uint256 _id, uint256 _amount) public payable {
        // TODO create a NFT media seller here
    }

    receive() external payable {
        // TODO evaluate with solidity patterns if this funcion make sense
        revert("No ether can sent direclty to this contract");
    }
}
