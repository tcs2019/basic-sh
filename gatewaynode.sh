#!/bin/sh
#
# Runs a gatewaynode with alpine_ethereum_gateway image
#
IMGNAME="kaiuofa/alpine_ethereum_gateway:latest"
NODE_NAME=$1
NODE_NAME=${NODE_NAME:-"gateway1"}
DETACH_FLAG=${DETACH_FLAG:-"-d"}
CONTAINER_NAME="ethereum-$NODE_NAME"
DATA_ROOT=${DATA_ROOT:-"$(pwd)/.ether-$NODE_NAME"}
DATA_HASH=${DATA_HASH:-"$(pwd)/.ethash"}
echo "Destroying old container $CONTAINER_NAME..."
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME
# TODO: change this to $2 and add flag -p
RPC_PORT="3000"
RPC_PORTMAP=
RPC_ARG=
if [[ ! -z $RPC_PORT ]]; then
    RPC_ARG='--ws --wsaddr=0.0.0.0 --wsport 8546 --wsapi=db,eth,net,web3,personal --wsorigins "*" --rpc --rpcaddr=0.0.0.0 --rpcport 8545 --rpcapi=db,eth,net,web3,personal --rpccorsdomain "*"'
    RPC_PORTMAP="-p $RPC_PORT:3000"
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
        $IMGNAME /bin/sh -c "geth init /opt/genesis.json"
    echo "...done!"
fi
echo "Running new container $CONTAINER_NAME..."
# TODO: Run new container with command to start server
docker run $DETACH_FLAG --name $CONTAINER_NAME \
    --network ethereum \
    -v $DATA_ROOT:/root/.ethereum \
    -v $DATA_HASH:/root/.ethash \
    -v $(pwd)/genesis.json:/opt/genesis.json \
    $RPC_PORTMAP \
    $IMGNAME --bootnodes=$BOOTNODE_URL $RPC_ARG --cache=512 --verbosity=4 --maxpeers=5 ${@:2}