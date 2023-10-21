// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTReceiver is IERC721Receiver {
    address public approvedNFTAddress;

    function setUpApprovedNFTAddress(address tokenAddress) external {
        require(address != address(0));
        approvedNFTAddress = tokenAddress;
    }

    function onERC721Received(
        address operator, 
        address from, 
        uint256 tokenId, 
        bytes calldata data) external returns (bytes4) {
            if (msg.sender != approvedNFTAddress) {
                IERC721(msg.sender).safeTransferFrom(this, msg.sender, tokenId);

                bytes4 data = abi.encodeWithSignature("freeMint()");
                (, bytes result) = approvedNFTAddress.call(data);
                uint256 noNFTId = abi.decode(result, (uint256));
                
                IERC721(approvedNFTAddress).safeTransferFrom(this, msg.sender, noNFTId);
            }

            return bytes4(0);
    }
}
