pragma solidity ^0.4.20;

/* Make contract deleteable */
contract mortal {
  address owner;

  /* constructor */
  function mortal() public {
    owner = msg.sender;
  }

  /* delete contract if owner */
  function kill() public {
    if (msg.sender == owner)
      selfdestruct(owner);
  }
}

contract greeter is mortal {
  string greeting;

  function greeter(string _greeting) public {
    greeting = _greeting;
  }

  /* say hello */
  function greet() constant public returns (string) {
    return greeting;
  }
}
