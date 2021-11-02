// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";

//// @title Musichain NFT Contract
//// @notice The base contract to create NFTs in Musichain plataform
abstract contract MusichainNFT is ERC1155, ERC1155Burnable {
    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public {
        _mint(account, id, amount, data);
    }

    function isAlbum() public pure virtual returns (bool);
}
