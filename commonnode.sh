#!/bin/sh
#
# Runs a normalnode with ethereum/client-go:latest image
#
IMGNAME="ethereum/client-go:latest"
NODE_NAME=$1
NODE_NAME=${NODE_NAME:-"node1"}
DETACH_FLAG=${DETACH_FLAG:-"-d"}
CONTAINER_NAME="ethereum-$NODE_NAME"
DATA_ROOT=${DATA_ROOT:-"$(pwd)/.ether-$NODE_NAME"}
DATA_HASH=${DATA_HASH:-"$(pwd)/.ethash"}
echo "Destroying old container $CONTAINER_NAME..."
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME
# TODO: merge this one & userconnectnode.sh & minernode.sh (-d:DETACH -p:PORTMAP -n:NODETYPE)
# https://unix.stackexchange.com/questions/31414/how-can-i-pass-a-command-line-argument-into-a-shell-script
RPC_PORTMAP=
RPC_ARG=
if [[ ! -z $RPC_PORT ]]; then
    RPC_ARG='--rpc --rpcaddr=0.0.0.0 --rpcport 8545 --rpcapi=db,eth,net,web3,personal --rpccorsdomain "*"'
    RPC_PORTMAP="-p $RPC_PORT:8545"
fi
BOOTNODE_URL=${BOOTNODE_URL:-$(./getbootnodeurl.sh)}
if [ ! -f $(pwd)/genesis.json ]; then
    echo "No genesis.json file found, please run 'genesis.sh'. Aborting."
    exit
fi
if [ ! -d $DATA_ROOT/keystore ]; then
    echo "$DATA_ROOT/keystore not found, running 'geth init'..."
    docker run --rm \
        -v $DATA_ROOT:/root/.ethereum \
        -v $(pwd)/genesis.json:/opt/genesis.json \
        $IMGNAME init /opt/genesis.json
    echo "...done!"
fi
echo "Running new container $CONTAINER_NAME..."
docker run $DETACH_FLAG --name $CONTAINER_NAME \
    --network ethereum \
    -v $DATA_ROOT:/root/.ethereum \
    -v $DATA_HASH:/root/.ethash \
    -v $(pwd)/genesis.json:/opt/genesis.json \
    $RPC_PORTMAP \
    $IMGNAME --bootnodes=$BOOTNODE_URL $RPC_ARG --cache=512 --verbosity=4 --maxpeers=5 ${@:2}