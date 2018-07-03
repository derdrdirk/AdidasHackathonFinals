# has to be executed from root folder
geth init ./genesis.json --datadir ./chain
geth --datadir ./chain --networkid 1234  --rpc --rpcapi eth,web3,personal,miner,admin --rpccorsdomain "*" --rpcport "8545" --rpcaddr "0.0.0.0" --ipcpath "$HOME/.ethereum/geth.ipc"
