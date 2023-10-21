// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SomeNFT is ERC721 {
    uint256 private totalSupply;

    constructor() ERC721("Some NFT", "Some") {}

    function freeMint() {
        _mint(msg.sender, totalSupply);
        totalSupply = totalSupply + 1;
    }
}