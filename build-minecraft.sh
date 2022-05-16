#!/bin/bash

## This script builds all of the release versions of vanilla minecraft

if ! command -v jq >/dev/null 2>&1; then
    echo "jq is missing";
    exit 1
fi

IMAGE_NAME=${IMAGE_NAME:-port3m5/minecraft}
IMAGE_NAME=$(echo $IMAGE_NAME | tr '[:upper:]' '[:lower:]')

manifest=$(curl -s 'https://launchermeta.mojang.com/mc/game/version_manifest.json')

latest=$(jq -r '.latest.release' <<< "$manifest")
versions=$(jq -r '.versions[] | select( .type == "release" )' <<< "$manifest")

for version in $(echo "$versions" | jq -cr); do
    minecraft_version=$(jq -r '.id' <<< "$version")

    if docker image inspect "$IMAGE_NAME:${minecraft_version}" > /dev/null 2>&1; then
        echo "Build of Vanilla $minecraft_version already exists, skipping"
        continue
    fi

    url=$(jq -r '.url' <<< "$version")

    data=$(curl -s "$url")

    java_version=$(jq -r '.javaVersion.majorVersion' <<< "$data")
    if [ "$java_version" == "null" ]; then
        java_version="8"
    fi
    server_url=$(jq -r '.downloads.server.url' <<< "$data")

    if [ "$server_url" == "null" ]; then
        echo "Release has no server defined, skipping"
        continue
    fi

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
            -t "$IMAGE_NAME" \
            minecraft

        docker push "$IMAGE_NAME"
    fi

done