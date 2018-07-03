pragma solidity ^0.4.16;

contract ClientOps {
    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 value);

    /* Send coins */
    function tryToTransfer(address _from, address _to, uint256 _value) public payable {
        /* Check if sender has balance and for overflows */
        require(balanceOf[_from] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);

        /* Add and subtract new balances */
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
    }
}