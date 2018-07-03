pragma solidity ^0.4.18;

contract dataholderContract {
  mapping (string => uint256) balanceOf;
  mapping(string => Dataholder) dataholders;
  struct Dataholder {
    bool shares;
    string password;
    string privateKey;
    string[] dataScientists;
    
  }
  
  function getBalanceOf(string user) constant public returns (uint256) {
      return balanceOf[user];
  }

  function dataholderContract (string coinbase) public {
      balanceOf[coinbase] = 20000000000;
  }
  
    function transfer(string _from, string _to, uint256 _value) public {
        require(balanceOf[_from] >= _value);           // Check if the sender has enough
        require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
        balanceOf[_from] -= _value;                    // Subtract from the sender
        balanceOf[_to] += _value;                           // Add the same to the recipient
    }
  
  function createDataholder(string _dataholderId, string _password, string _privateKey) public {
      dataholders[_dataholderId].shares = false;
      dataholders[_dataholderId].password = _password;
      dataholders[_dataholderId].privateKey = _privateKey;
  }
  
  function addDataScientistToDataholder(string _dataScientistId, string _dataholderId) public {
      dataholders[_dataholderId].dataScientists.push(_dataScientistId);
  }
  
  function changeDataholderSharing(string _dataholderId, string _password, bool _shares) public returns (string) {
      if(keccak256(dataholders[_dataholderId].password) == keccak256(_password)) {
        dataholders[_dataholderId].shares = _shares;
        return "Sharing changed";
      }
      return "Wrong userId/ password";
  }
  
  function getDataholder(string _dataholderId) constant public returns (string, string) {
      return (dataholders[_dataholderId].password, dataholders[_dataholderId].privateKey);
  }
  
  function getKey(string _dataholderId, string _dataScientistId) public payable returns (string) {
    uint arrayLength = dataholders[_dataholderId].dataScientists.length;
    for (uint i=0; i<arrayLength; i++) {
      if(keccak256(dataholders[_dataholderId].dataScientists[i]) == keccak256(_dataScientistId)) {
          transfer(_dataScientistId, _dataholderId, 1);
          return dataholders[_dataholderId].privateKey;
      }
    }
    return "forbidden";
  }
  
  function queryData(string _dataholderId, string _dataScientistId, string _buyerId) public {
      transfer(_buyerId, _dataholderId, 2);
      transfer(_buyerId, _dataScientistId, 7);
      transfer(_buyerId, "0xa6ba6a2aed90939f931c1f33be2fbb3ad250a833", 1);
  }

  function getKeyFromDataholder(string _dataholderId) constant public returns (string) {
      if(dataholders[_dataholderId].shares) {
         return (dataholders[_dataholderId].privateKey);
      }
      return ("forbidden");
  }
}
