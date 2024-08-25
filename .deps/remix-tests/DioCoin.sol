// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    //getters
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    //functions
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256);
}

contract DIOToken is IERC20 {
    string public constant name = "Test Token";
    string public constant symbol = "DIO";
    uint8 public constant decimals = 6;

    mapping(address => uint256) balances;

    mapping(address => mapping(address => uint256)) allowed;

    uint256 totalSupply_ = 10 ether;

    constructor() {
        balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public view override returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner)
        public
        view
        override
        returns (uint256)
    {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens)
        public
        override
        returns (bool)
    {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender] - numTokens;
        balances[receiver] = balances[receiver] + numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens)
        public
        override
        returns (bool)
    {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate)
        public
        view
        override
        returns (uint256)
    {
        return allowed[owner][delegate];
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {
        require(amount <= balances[from]);
        require(amount <= allowed[from][msg.sender]);

        uint256 fee = (amount * feeRate) / 1000; // Adjust fee rate as needed
        uint256 actualTransferAmount = amount - fee;

        balances[from] -= actualTransferAmount;
        allowed[from][msg.sender] -= actualTransferAmount;
        balances[to] += actualTransferAmount;

        emit Transfer(from, to, actualTransferAmount);

        return true;
    }
}
