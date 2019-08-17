#!/usr/bin/env bash

set -e

# Start graph-node so we can inspect it
docker-compose start graph-node

# Identify the container ID
CONTAINER_ID=$(docker container ls | grep graph-node | cut -d' ' -f1)

# Inspect the container to identify the host IP address
HOST_IP=$(docker inspect "$CONTAINER_ID" | jq -r .[0].NetworkSettings.Networks[].Gateway)

echo "Host IP: $HOST_IP"

# Inject the host IP into docker-compose.yml
sed -i -e "s/host.docker.internal/$HOST_IP/g" docker-compose.yml

function stop_graph_node {
    # Ensure graph-node is stopped
    docker-compose stop graph-node
}

trap stop_graph_node EXIT
