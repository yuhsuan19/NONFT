// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {NONFT} from "../src/NONFT.sol";
import {SomeNFT} from "../src/SomeNFT.sol";
import {NFTReceiver} from "../src/NFTReceiver.sol";


contract HomeworkTest is Test {
    NONFT public noNFT;
    SomeNFT public someNFT;
    NFTReceiver public nftReceiver;
    address user1;

    function setUp() public {
        user1 = makeAddr("user1");
        deal(user1, 1 ether);

        noNFT = new NONFT();
        someNFT = new SomeNFT();

        nftReceiver = new NFTReceiver();
        nftReceiver.setUpApprovedNFTAddress(address(noNFT));
    }

    function test_SomeNFTSafeTransferFrom() public {
        uint256 tokenId;

        vm.startPrank(user1);
        (, bytes memory mintData) = address(someNFT).call(abi.encodeWithSignature("freeMint()"));
        tokenId = abi.decode(mintData, (uint256));
        address(someNFT).call(abi.encodeWithSignature("safeTransferFrom(address,address,uint256)", user1, address(nftReceiver), tokenId));
        vm.stopPrank();

        (, bytes memory ownerData) = address(someNFT).call(abi.encodeWithSignature("ownerOf(uint256)", tokenId));
        address ownerAddr = abi.decode(ownerData, (address));

        // check owner of some nft
        assertEq(ownerAddr, user1);

        (, bytes memory balanceData) = address(noNFT).call(abi.encodeWithSignature("balanceOf(address)", user1));
        uint256 bal = abi.decode(balanceData, (uint256));
        assertEq(bal, 1);
    }

    function test_NoNFTSafeTransferFrom() public {
        uint256 tokenId;

        vm.startPrank(user1);
        (, bytes memory mintData) = address(noNFT).call(abi.encodeWithSignature("freeMint()"));
        tokenId = abi.decode(mintData, (uint256));
        address(noNFT).call(abi.encodeWithSignature("safeTransferFrom(address,address,uint256)", user1, address(nftReceiver), tokenId));
        vm.stopPrank();

        (, bytes memory ownerData) = address(noNFT).call(abi.encodeWithSignature("ownerOf(uint256)", tokenId));
        address ownerAddr = abi.decode(ownerData, (address));

        assertEq(ownerAddr, address(nftReceiver));
    }

    function test_NONFTMint() public {
        uint256 tokenId;
        vm.startPrank(user1);
        (, bytes memory mintData) = address(noNFT).call(abi.encodeWithSignature("freeMint()"));
        tokenId = abi.decode(mintData, (uint256));
        vm.stopPrank();

        (, bytes memory ownerData) = address(noNFT).call(abi.encodeWithSignature("ownerOf(uint256)", tokenId));
        address ownerAddr = abi.decode(ownerData, (address));
        
        assertEq(ownerAddr, user1);
    }

    function test_SomeNFTMint() public {
        uint256 tokenId;
        
        vm.startPrank(user1);
        (, bytes memory mintData) = address(someNFT).call(abi.encodeWithSignature("freeMint()"));
        tokenId = abi.decode(mintData, (uint256));
        vm.stopPrank();

        (, bytes memory ownerData) = address(someNFT).call(abi.encodeWithSignature("ownerOf(uint256)", tokenId));
        address ownerAddr = abi.decode(ownerData, (address));

        assertEq(ownerAddr, user1);
    }
}
