#!/bin/bash

## This script builds and pushes the latest build of each version of paper

if ! command -v jq >/dev/null 2>&1; then
    echo "jq is missing";
    exit 1
fi

IMAGE_NAME=${IMAGE_NAME:-port3m5/paper}
IMAGE_NAME=$(echo "$IMAGE_NAME" | tr '[:upper:]' '[:lower:]')

# Build Paper
versions=$(curl -s 'https://papermc.io/api/v2/projects/paper' | jq -r ".version_groups[]")

for version in $versions; do
    build=$(curl -s "https://papermc.io/api/v2/projects/paper/version_group/${version}/builds" | jq .builds[-1])

    version=$(jq -r '.version' <<< "$build")
    build_id=$(jq -r '.build' <<< "$build")

    if docker image inspect "$IMAGE_NAME:${version}-${build_id}" > /dev/null 2>&1; then
        echo "Build of Paper $version build $build_id already exists, skipping"
        continue
    fi

    echo "Building Paper $version build $build_id"

    docker build \
        --build-arg MINECRAFT_VERSION="$version" \
        --build-arg=BUILD_NUMBER="$build_id" \
        -t "$IMAGE_NAME" \
        -t "$IMAGE_NAME:${version}" \
        -t "$IMAGE_NAME:${version}-${build_id}" \
        paper

    docker push "$IMAGE_NAME:${version}"
    docker push "$IMAGE_NAME:${version}-${build_id}"
done

# Last build is latest
docker push "$IMAGE_NAME"
