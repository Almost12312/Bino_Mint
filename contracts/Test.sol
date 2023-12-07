// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Test is ERC721, Ownable {
    uint256 public price = 0.005 ether;

    uint256 public maxSupply;
    uint256 public totalSupply;

    bool public isActive;

    mapping (address => uint8) holders;

    constructor() ERC721("Test", "TT") Ownable(msg.sender) payable  {
        maxSupply = 3;
    }

    function toggleActive() external onlyOwner {
        isActive = !isActive;
    }

    function setMaxSupply(uint256 _maxSupply) external onlyOwner {
        maxSupply = _maxSupply;
    }

    function mint() external payable {
        require(isActive, "Mint not enabled!");

        require(holders[msg.sender] < 1, "you can't mint over 1 NFT");
        require(msg.value == price, "wrong value");
        require(maxSupply > totalSupply, "sold out");

        holders[msg.sender]++;
        totalSupply++;

        uint256 tokenId = totalSupply;
        _safeMint(msg.sender, tokenId);
    }
}