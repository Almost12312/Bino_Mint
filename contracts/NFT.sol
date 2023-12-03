// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721, Ownable {
    using Strings for uint256;

    uint256 public constant MAX_TOKENS = 10;

    uint256 public constant MAX_WALLET_TOKENS = 10;
    uint256 private constant RESERVED = 5;

    uint256 public price = 8000000000000000;
    uint256 public constant MINT_PER_TX = 3;
    
    bool IsSaleActive = true;

    uint256 public totalSupply;
    mapping(address => uint256) private mintedPerWallet;

    string baseURI;
    string baseExtension = ".json";

    constructor() ERC721("BinoTest", "BT") Ownable(msg.sender) {
        baseURI = "ipfs://xx";

        for (uint256 i = 0; i < RESERVED; i++) {
            _safeMint(msg.sender, i);

            totalSupply = RESERVED;
        }
    }

    function mint(uint256 _amountTokens) external payable {
        require(IsSaleActive, "Sale is't active!");
        require(_amountTokens <= MINT_PER_TX, "You can mint only 10 NFTs per transaction");
        require(mintedPerWallet[msg.sender] + _amountTokens <= MAX_WALLET_TOKENS, "You can mint only `MAX_WALLET_TOKENS` per wallet");
        uint256 currentSupply = totalSupply;
        require(currentSupply + _amountTokens <= MAX_TOKENS, "Exeeds total supply");
        require(_amountTokens + price < msg.value, "Insufficient balance");

        for (uint256 i = 0; i < _amountTokens; i++) 
        {
            _safeMint(msg.sender, currentSupply + i);
        }

        mintedPerWallet[msg.sender] += _amountTokens;
        totalSupply += _amountTokens; 
    }

    function flipState() external onlyOwner {
        IsSaleActive = !IsSaleActive;
    }

    function setBaseUri(string memory uri) external onlyOwner {
        baseURI = uri;
    }

    function setPrice(uint256 _price) external onlyOwner {
        price = _price;
    }

    function withdrawAll() external payable onlyOwner {
        uint256 balance = address(this).balance;

        (bool transfer, ) = payable(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4).call{value: balance}("");
        require(transfer, "Transfer failed.");
    }

     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireOwned(tokenId);
 
        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0
            ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
            : "";
    }
 
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }
}