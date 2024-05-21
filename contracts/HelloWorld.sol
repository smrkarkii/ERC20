//SPDX-License-Identifier:MIT

pragma solidity ^0.8.9;

contract HelloWorld {
    //state variable
    uint storedNumber;

    //constructor to initialize the contract with some number
    constructor(uint _number) {
        storedNumber = _number;
    }

    //Functions

    //function to store an unsigned integer
    function storeNumber(uint _storedNumber) public {
        storedNumber = _storedNumber;
    }

    //function to retrieve stored number
    function retrieveNumber() public view returns (uint) {
        return storedNumber;
    }
}
