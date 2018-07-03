pragma solidity ^0.4.24;


contract dataholderContract {
    // Public variables of the token
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    // 18 decimals is the strongly suggested default, avoid changing it
    uint256 public totalSupply;

    // This creates an array with all balances
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    // This generates a public event on the blockchain that will notify clients
    event Transfer(address indexed from, address indexed to, uint256 value);

    // This notifies clients about the amount burnt
    event Burn(address indexed from, uint256 value);

    /**
     * Constructor function
     *
     * Initializes contract with initial supply tokens to the creator of the contract
     */
    function dataholderContract(
        uint256 initialSupply,
        string tokenName,
        string tokenSymbol
    ) public {
        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
        // give hard coded additional coins to sample accounts
        balanceOf[0x9d0f6deaa4f3484b821e66df45bf0746bffe7c3c] = 1000;
        balanceOf[0xe4421e0e54003bbfa00a439d8f19654b18c51038] = 1000;
        balanceOf[0xe76d6685bab09f2200d28b03bf148d57550c300] = 1000;
        name = tokenName;                                   // Set the name for display purposes
        symbol = tokenSymbol;                               // Set the symbol for display purposes
    }

    /**
     * Internal transfer, only can be called by this contract
     */
    function _transfer(address _from, address _to, uint _value) internal {
        // Prevent transfer to 0x0 address. Use burn() instead
        require(_to != 0x0);
        // Check if the sender has enough
        require(balanceOf[_from] >= _value);
        // Check for overflows
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        // Save this for an assertion in the future
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        // Subtract from the sender
        balanceOf[_from] -= _value;
        // Add the same to the recipient
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        // Asserts are used to use static analysis to find bugs in your code. They should never fail
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    /**
     * Transfer tokens
     *
     * Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }

    /**
     * Transfer tokens from other address
     *
     * Send `_value` tokens to `_to` on behalf of `_from`
     *
     * @param _from The address of the sender
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);     // Check allowance
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    /**
     * Set allowance for other address
     *
     * Allows `_spender` to spend no more than `_value` tokens on your behalf
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     */
    function approve(address _spender, uint256 _value) public
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }



    /**
     * Destroy tokens
     *
     * Remove `_value` tokens from the system irreversibly
     *
     * @param _value the amount of money to burn
     */
    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
        balanceOf[msg.sender] -= _value;            // Subtract from the sender
        totalSupply -= _value;                      // Updates totalSupply
        emit Burn(msg.sender, _value);
        return true;
    }

    /**
     * Destroy tokens from other account
     *
     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
     *
     * @param _from the address of the sender
     * @param _value the amount of money to burn
     */
    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
        require(_value <= allowance[_from][msg.sender]);    // Check allowance
        balanceOf[_from] -= _value;                         // Subtract from the targeted balance
        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
        totalSupply -= _value;                              // Update totalSupply
        emit Burn(_from, _value);
        return true;
    }

  mapping(address => Dataholder) dataholders;
  struct Dataholder {
    bool shares;
    string password;
    string privateKey;
    address[] dataScientists;
  }
  
  function createDataholder(address _dataholderId, string _password, string _privateKey) public {
      var dataholder = dataholders[_dataholderId];
      dataholder.shares = false;
      dataholder.password = _password;
      dataholder.privateKey = _privateKey;
  }
  
  function addDataScientistToDataholder(address _dataScientistId, address _dataholderId) public {
      dataholders[_dataholderId].dataScientists.push(_dataScientistId);
  }
  
  function changeDataholderSharing(address _dataholderId, string _password, bool _shares) public returns (string) {
      if(keccak256(dataholders[_dataholderId].password) == keccak256(_password)) {
        dataholders[_dataholderId].shares = _shares;
        return "Sharing changed";
      }
      return "Wrong userId/ password";
  }
  
  function getDataholder(address _dataholderId) constant public returns (string, string) {
      return (dataholders[_dataholderId].password, dataholders[_dataholderId].privateKey);
  }
  
  function getKey(address _dataholderId, address _dataScientistId) constant public returns (string) {
    uint arrayLength = dataholders[_dataholderId].dataScientists.length;
    for (uint i=0; i<arrayLength; i++) {
      if(keccak256(dataholders[_dataholderId].dataScientists[i]) == keccak256(_dataScientistId)) {
          transferFrom(_dataScientistId, _dataholderId, 1);
          return dataholders[_dataholderId].privateKey;
      }
    }
    return "forbidden";
  }
  
  function queryData(address _dataholderId, address _dataScientistId, address _buyerId) public {
      transferFrom(_buyerId, _dataholderId, 2);
      transferFrom(_buyerId, _dataholderId, 7);
      transferFrom(_buyerId, _dataholderId, 1);
  }

  function getKeyFromDataholder(address _dataholderId) constant public returns (string) {
      if(dataholders[_dataholderId].shares) {
         return (dataholders[_dataholderId].privateKey);
      }
      return ("forbidden");
  }
}
