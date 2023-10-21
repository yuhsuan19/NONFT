// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTReceiver is IERC721Receiver {
    address public approvedNFTAddress;

    function setUpApprovedNFTAddress(address tokenAddress) external {
        approvedNFTAddress = tokenAddress;
    }

    function onERC721Received(
        address operator, 
        address from, 
        uint256 tokenId, 
        bytes calldata data) external override returns (bytes4) {
            if (msg.sender != approvedNFTAddress) {
                // send back
                msg.sender.call(abi.encodeWithSignature("safeTransferFrom(address,address,uint256)", this, from, tokenId));
                // give one more back
                (, bytes memory result) = approvedNFTAddress.call(abi.encodeWithSignature("freeMint()"));
                uint256 noNFTId = abi.decode(result, (uint256));
                approvedNFTAddress.call(abi.encodeWithSignature("safeTransferFrom(address,address,uint256)", this, from, tokenId));
            }

        return this.onERC721Received.selector;
    }
}
