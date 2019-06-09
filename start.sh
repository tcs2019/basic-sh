#!/bin/sh

./genesis.sh
# start some basic nodes
./bootnode.sh
./normalnode.sh
# start a normal node with portmap=8545 for RPC connection
./userconnectnode.sh
# start a miner node
./minernode.sh
# start a gateway node with portmap=3000 for express connection
./gatewaynode.sh

# TODO: run this to create new account
# docker exec -ti ethereum-node1 geth --datadir .ether-node1 account new