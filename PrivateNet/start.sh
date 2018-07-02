# has to be executed from root folder
geth init ./PrivateNet/genesis.json --datadir ./PrivateNet/chain
geth --datadir ./PrivateNet/chain --networkid 9987  --rpc --rpcapi eth,web3,personal,admin,miner --rpccorsdomain "*" --rpcport "8545" --rpcaddr "0.0.0.0"
