// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract Test {
    mapping (address => string) public map;

    function setAddress(address addr) public {
        map[addr] = "bibki";
    }

    function getInfo(address addr) public view returns (string memory) {
        return map[addr];
    } 
}