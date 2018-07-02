# has to be executed from root folder
geth init ./PrivateNet/genesis.json --datadir ./PrivateNet/chain
geth --datadir ./PrivateNet/chain --networkid 1234 --port 30303 --rpc --rpcport 8545 --rpcaddr="0.0.0.0" --rpcapi "web,eth,personal,admin,miner" --rpccorsdomain "*"
