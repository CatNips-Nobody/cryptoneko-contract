// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CryptoNeko is ERC721, Ownable  {
    using Strings for uint256;

    bool public hasSaleStarted = false;
    string public METADATA_PROVENANCE_HASH = "";
    uint256 public MAX_NEKO_CAT = 64;
    uint256 public MAX_TOTAL_NEKO_CAT = 128;
    uint256 internal numTokens = 0;

    // Base URI
    string private baseURI;
   constructor() ERC721("CryptoNeko", "CryptoNeko") {
      
    }
    function totalSupply() public view returns (uint256) {
        return numTokens;
    }
    function tokensOfOwner(address catowner) external view returns(uint256[] memory ) {
        uint256 tokenCount = balanceOf(catowner);
        if (tokenCount == 0) {
            // Return an empty array
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](tokenCount);
            uint256 index;
            index = 0;
            uint256 tokenId;
            for (tokenId = 1; tokenId <= numTokens; tokenId++) {
                if(ownerOf(tokenId) == catowner){
                    result[index] = tokenId; 
                }
                index++;
            }
            return result;
        }
    }

    // set the price
    function calculatePrice() internal view returns (uint256) {
        uint256 price;
        if (numTokens < 16) {
        price = 20000000000000000; //0.02
        } else if (numTokens >= 16 && numTokens < 32) {
        price = 40000000000000000; //0.04
        } else if (numTokens >= 32 && numTokens < 48) {
        price = 60000000000000000; //0.06
        } else if (numTokens >= 48 && numTokens < 64) {
        price = 80000000000000000; //0.08
        } else {
        price = 1000000000000000000; //0.1
    }
    return price;
    }
    
    
    function createCat() public payable {        
        require(hasSaleStarted == true, "Sale hasn't started");
        require(numTokens < MAX_NEKO_CAT,"ERC721: maximum number of tokens already minted");
        require(msg.value >= calculatePrice(), "ERC721: insufficient ether");
        _safeMint(msg.sender, numTokens);
       numTokens += 1;   

    }


    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    // ONLYOWNER FUNCTIONS
    
    function setProvenanceHash(string memory _hash) public onlyOwner {
        METADATA_PROVENANCE_HASH = _hash;
    }
    
    function setBaseURI(string memory _setBaseURI) public onlyOwner {
        baseURI = _setBaseURI;
    }
    
    function startDrop() public onlyOwner {
        hasSaleStarted = true;
    }
    function pauseDrop() public onlyOwner {
        hasSaleStarted = false;
    }

    function withdrawAll() public payable onlyOwner {
        require(payable(msg.sender).send(address(this).balance));
    }

    function createRewardCat() public onlyOwner {        
        require(numTokens < MAX_TOTAL_NEKO_CAT,"ERC721: maximum number of tokens already minted");
        uint256 id = numTokens;
        _safeMint(msg.sender, id);
        numTokens = numTokens + 1; 

    }
        
    function testmint(uint256 _numCat ) public {
        for (uint256 i = 0; i < _numCat; i++) {
            uint256 id = numTokens;
            _safeMint(msg.sender, id);
            numTokens = numTokens + 1;   
        }
    }
    
}