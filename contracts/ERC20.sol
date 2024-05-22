//SPDX-License-Identifier:MIT

pragma solidity ^0.8.9;

//mintable and burnable ERC20 tokens
contract ERC20 {
    //state variable
    uint private totalTokens; //total no of tokens
    string private token; //Token name
    string private sym; //Token symbol
    address public owner; //contract owner

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowances;

    //constructor for the token
    constructor(string memory _name, string memory _sym) {
        token = _name;
        sym = _sym;
        owner = msg.sender;

        // emit tokenTransferred(address(0), msg.sender, _totalTokens);
    }

    //modifier
    modifier onlyOwner() {
        require(owner == msg.sender, "You are not an owner");
        _;
    }

    //Events
    event tokenMinted(address to, uint value);
    event tokenBurnt(address from, uint256 value);
    event tokenTransferred(address from, address to, uint value);
    event tokenApproved(address tokenOwner, address sender, uint value);

    //functions

    //function to return name of the token
    function name() public view returns (string memory) {
        return token;
    }

    //function to return symbol of the token
    function symbol() public view returns (string memory) {
        return sym;
    }

    //function to return symbol of the token
    function totalSupply() public view returns (uint) {
        return totalTokens;
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    //function to return the balance of address
    function balanceOf(address _owner) public view returns (uint) {
        return balances[_owner];
    }

    //function to send some token from sender to receiver
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0), "can't trasfer to the given address 0X00");
        require(
            balances[msg.sender] >= _value,
            "You can't transfer tokens more than you have"
        );
        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value;
        emit tokenTransferred(msg.sender, _to, _value);
        return true;
    }

    //function to allow 3rd party to transfer tokens

    function approve(address sender, uint value) public returns (bool) {
        require(sender != address(0), "can't approve the given address 0X00");
        allowances[msg.sender][sender] = value;
        emit tokenApproved(msg.sender, sender, value);
        return true;
    }

    //function to send some ether from sender to receiver by 3rd party
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool) {
        require(balances[_from] >= _value, "Not enough tokens");
        require(_to != address(0), "can't trasfer to the given address 0X00");
        require(_from != address(0), "can't trasfer from given address 0X00");
        require(
            allowances[_from][msg.sender] >= _value,
            "You can only spend the approved no of tokens"
        );
        balances[_from] = balances[_from] - _value;
        balances[_to] = balances[_to] + _value;
        allowances[_from][msg.sender] = allowances[_from][msg.sender] - _value;
        emit tokenTransferred(_from, _to, _value);
        return true;
    }

    //function to mint token to some address
    function mint(address to, uint256 value) public onlyOwner {
        require(to != address(0), "Can't be transferredto given account 0X00");

        balances[to] = balances[to] + value;
        totalTokens = totalTokens + value;
        emit tokenMinted(to, value);
    }

    //Only the token holders can burn tokens
    function burn(uint256 value) public {
        require(
            balances[msg.sender] >= value,
            "You can't burn more tokens than you have"
        );

        balances[msg.sender] = balances[msg.sender] - value;
        totalTokens = totalTokens - value;
        emit tokenBurnt(msg.sender, value);
    }

    function allowance(
        address addr1,
        address addr2
    ) public view returns (uint) {
        return allowances[addr1][addr2];
    }
}
