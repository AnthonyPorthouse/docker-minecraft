#!/bin/bash

if ! command -v jq >/dev/null 2>&1; then
    echo "jq is missing" > /dev/stderr
    exit 1
fi

latest="${LATEST_VERSION:-}"
version="${VERSION:-}"

fabric_version="$version"

echo "Building Fabric $fabric_version"

docker build \
    --build-arg FABRIC_VERSION="$fabric_version" \
    -t "$IMAGE_NAME" \
    -t "$IMAGE_NAME:${fabric_version}" \
    fabric

docker push "$IMAGE_NAME:${fabric_version}"

if [ "$version" == "$latest" ]; then
    docker push "$IMAGE_NAME"
fi
