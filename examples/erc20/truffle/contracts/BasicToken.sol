pragma solidity ^0.4.18;


import "./ERC20Basic.sol";


/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
    event Buy(address buyer, uint256 amount);

    string public name = "Pene Token";
    string public symbol = "PTKN";
    uint8 public decimals = 18;

    mapping(address => uint256) private balances;
    uint256 private totalSupply_;
    uint256 private price_;

    function BasicToken(uint256 _totalSupply, uint256 _price) public {
        totalSupply_ = _totalSupply;
        price_ = _price;
    }

    function price() public view returns (uint256) {
        return price_;
    }

    /* *
    * @dev total number of tokens in existence
    */
    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }

    function buy() public payable returns (bool) {
        uint256 amount = msg.value / price_;
        balances[msg.sender] = balances[msg.sender] + amount;
        totalSupply_ = totalSupply_ + amount;

        Buy(msg.sender, amount);
        return true;
    }

    /**
    * @dev transfer token for a specified address
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    */
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);

        // SafeMath.sub will throw if there is not enough balance.
        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param _owner The address to query the the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

}
