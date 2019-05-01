#!/bin/sh
#
# Runs a minernode with ethereum/client-go:latest image
#
NODE_NAME=$1
NODE_NAME=${NODE_NAME:-"miner1"}
ETHERBASE=${ETHERBASE:-"0x0000000000000000000000000000000000000001"}
./commonnode.sh $NODE_NAME --mine --minerthreads=1 --etherbase="$ETHERBASE"