pragma solidity ^0.4.24;

contract dataholderContract {
  mapping(string => Dataholder) dataholders;
  struct Dataholder {
    bool shares;
    string password;
    string privateKey;
    string[] dataScientists;
  }

  constructor () public {}
  
  function createDataholder(string _dataholderId, string _password, string _privateKey) public {
      var dataholder = dataholders[_dataholderId];
      dataholder.shares = false;
      dataholder.password = _password;
      dataholder.privateKey = _privateKey;
  }
  
  function addPermissions(string _dataholderId, string _dataScientistId) public {
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
  
  function getKey(string _dataholderId, string _dataScientistId) constant public returns (string) {
    uint arrayLength = dataholders[_dataholderId].dataScientists.length;
    for (uint i=0; i<arrayLength; i++) {
      if(keccak256(dataholders[_dataholderId].dataScientists[i]) == keccak256(_dataScientistId)) {
          return dataholders[_dataholderId].privateKey;
      }
    }
    return "forbidden";
  }

  function getKeyFromDataholder(string _dataholderId) constant public returns (string) {
      if(dataholders[_dataholderId].shares) {
         return (dataholders[_dataholderId].privateKey);
      }
      return ("forbidden");
  }
}
