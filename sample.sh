#!/bin/bash

# Replace these variables with your Ethereum node URL and port
NODE_URL="http://localhost:8545"

# Function to get Ethereum node status
get_node_status() {
    echo "Ethereum Node Status:"

    # Get syncing status
    syncing=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}' -H "Content-Type: application/json" $NODE_URL)
    if [[ "$syncing" == *"false"* ]]; then
        block_height=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":83}' -H "Content-Type: application/json" $NODE_URL)
        echo "Syncing: Complete"
        echo "Latest Block: $block_height"
    else
        echo "Syncing: In progress"
        current_block=$(echo "$syncing" | jq -r '.result.currentBlock')
        highest_block=$(echo "$syncing" | jq -r '.result.highestBlock')
        echo "Current Block: $current_block"
        echo "Highest Block: $highest_block"
    fi

    # Get number of peers connected
    peer_count=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' -H "Content-Type: application/json" $NODE_URL)
    echo "Number of Peers Connected: $peer_count"

    # Get Ethereum client version
    client_version=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":1}' -H "Content-Type: application/json" $NODE_URL | jq -r '.result')
    echo "Ethereum Client Version: $client_version"

    # Get peer information
    peers_info=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"admin_peers","params":[],"id":1}' -H "Content-Type: application/json" $NODE_URL)
    echo "Peer Information:"
    echo "$peers_info" | jq -r '.result[] | "ID: \(.id), Name: \(.name), Network: \(.network.remoteAddress), Caps: \(.caps)"'
}

get_node_status
