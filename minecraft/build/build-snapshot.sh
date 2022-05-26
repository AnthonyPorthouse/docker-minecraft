#!/bin/bash

if ! command -v jq >/dev/null 2>&1; then
    echo "jq is missing" > /dev/stderr
    exit 1
fi

latest="${LATEST_VERSION:-}"
version="${VERSION:-}"

IMAGE_NAME=${IMAGE_NAME:-port3m5/minecraft}
IMAGE_NAME=$(echo "$IMAGE_NAME" | tr '[:upper:]' '[:lower:]')

minecraft_version=$(jq -r '.id' <<< "$version")

url=$(jq -r '.url' <<< "$version")

data=$(curl -s "$url")

java_version=$(jq -r '.javaVersion.majorVersion' <<< "$data")
if [ "$java_version" == "null" ]; then
    java_version="8"
fi
server_url=$(jq -r '.downloads.server.url' <<< "$data")

if [ "$server_url" == "null" ]; then
    echo "Release has no server defined, skipping" > /dev/stderr
    exit 0
fi

set -x

docker build \
    --build-arg MINECRAFT_VERSION="$minecraft_version" \
    --build-arg SERVER_URL="$server_url" \
    --build-arg JAVA_IMAGE="eclipse-temurin:$java_version-alpine" \
    -t "$IMAGE_NAME:${minecraft_version}" \
    minecraft

docker push "$IMAGE_NAME:${minecraft_version}"

if [ "$minecraft_version" == "$latest" ]; then
    docker build \
        --build-arg MINECRAFT_VERSION="$minecraft_version" \
        --build-arg SERVER_URL="$server_url" \
        --build-arg JAVA_IMAGE="eclipse-temurin:$java_version-alpine" \
        -t "$IMAGE_NAME:latest-snapshot" \
        minecraft

    docker push "$IMAGE_NAME:latest-snapshot"
fi