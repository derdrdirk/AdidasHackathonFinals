# has to be executed from root folder
geth init ./PrivateNet/genesis.json --datadir ./PrivateNet/chain
<<<<<<< HEAD
geth --datadir ./PrivateNet/chain --networkid 1234  --rpc --rpcapi eth,web3,personal,miner,admin --rpccorsdomain "*" --rpcport "8545" --rpcaddr "0.0.0.0"
=======
geth --datadir ./PrivateNet/chain --networkid 9987  --rpc --rpcapi eth,web3,personal,admin,miner --rpccorsdomain "*" --rpcport "8545" --rpcaddr "0.0.0.0"
>>>>>>> 0bd6531fe59167ca80d58d1319e6dcc3cce187e2
