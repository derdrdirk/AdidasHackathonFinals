pragma solidity ^0.4.16;

contract Adidasium {
    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;

    function Adidasium(uint256 initialSupply) public {
        balanceOf[msg.sender] = initialSupply;
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) public {
        /* Check if sender has balance and for overflows */
        require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);

        /* Add and subtract new balances */
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
    }


}
