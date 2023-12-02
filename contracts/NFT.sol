// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is Ownable, ERC721 {
    using Strings for uint256;

    uint256 public constant MAX_TOKENS = 10;
    uint256 private constant RESERVED = 5;

    uint256 public price = 8000000000000000;
    uint256 public constant mintPerTx = 3;
    
    bool IsSaleActive = true;

    uint256 public totalSupply;
    mapping(address => uint256) private mintedPerWallet;

    string baseURI;
    string baseExtensions = ".json";

    constructor() ERC721("BinoTest", "BT") Ownable(msg.sender) {
        baseURI = "ipfs://xx";

        for (uint256 i = 0; i < RESERVED; i++) {
            _safeMint(msg.sender, i);

            totalSupply = RESERVED;
        }
    }
}