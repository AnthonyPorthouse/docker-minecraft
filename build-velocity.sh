#!/bin/bash

## This script builds and pushes the latest build of each version of velocity

# Build Velocity
versions=$(curl -s 'https://papermc.io/api/v2/projects/velocity' | jq -r ".version_groups[]")

IMAGE_NAME=${IMAGE_NAME:-port3m5/velocity}
IMAGE_NAME=$(echo "$IMAGE_NAME" | tr '[:upper:]' '[:lower:]')

for version in $versions; do
    build=$(curl -s "https://papermc.io/api/v2/projects/velocity/version_group/${version}/builds" | jq .builds[-1])

    version=$(jq -r '.version' <<< "$build")
    build_id=$(jq -r '.build' <<< "$build")

    echo "Building Velocity $version build $build_id"

    docker build \
        --build-arg VELOCITY_VERSION="$version" \
        --build-arg=BUILD_NUMBER="$build_id" \
        -t "$IMAGE_NAME" \
        -t "$IMAGE_NAME:${version}" \
        -t "$IMAGE_NAME:${version}-${build_id}" \
        velocity

    docker push "$IMAGE_NAME:${version}"
    docker push "$IMAGE_NAME:${version}-${build_id}"
done;

docker push "$IMAGE_NAME"