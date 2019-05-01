#!/bin/sh
#
# Create genesis.json from genesis.json.template
#

GEN_NONCE="0xeddeadbabeeddead"
GEN_CHAIN_ID=15
GEN_ALLOC='"0x0000000000000000000000000000000000000001": {"balance": "11111111111111111111111111111111"}'
sed "s/\${GEN_NONCE}/$GEN_NONCE/g" genesis/genesis.json.template | sed "s/\${GEN_ALLOC}/$GEN_ALLOC/g" | sed "s/\${GEN_CHAIN_ID}/$GEN_CHAIN_ID/g" > genesis.json
