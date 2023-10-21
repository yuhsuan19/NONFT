// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NONFT is ERC721 {
    uint256 private totalSupply;

    constructor() ERC721("Don't send NFT to me", "NONFT") {}

    function tokenURI(uint256 tokenId) public view override virtual returns (string memory) {
        return "https://imgur.com/IBDi02f";
    }

    function freeMint() external returns (uint256) {
        uint256 tokenId = totalSupply;

        _mint(msg.sender, tokenId);
        totalSupply = totalSupply + 1;

        return tokenId;
    }
}