#!/bin/bash

if ! command -v jq >/dev/null 2>&1; then
    echo "jq is missing" > /dev/stderr
    exit 1
fi

latest="${LATEST_VERSION:-}"
version="${VERSION:-}"

build=$(curl -s "https://papermc.io/api/v2/projects/velocity/version_group/${version}/builds" | jq .builds[-1])

velocity_version=$(jq -r '.version' <<< "$build")
build_id=$(jq -r '.build' <<< "$build")

echo "Building Velocity $velocity_version build $build_id"

docker build \
    --build-arg VELOCITY_VERSION="$velocity_version" \
    --build-arg=BUILD_NUMBER="$build_id" \
    -t "$IMAGE_NAME" \
    -t "$IMAGE_NAME:${velocity_version}" \
    -t "$IMAGE_NAME:${velocity_version}-${build_id}" \
    velocity

docker push "$IMAGE_NAME"
docker push "$IMAGE_NAME:${velocity_version}"
docker push "$IMAGE_NAME:${velocity_version}-${build_id}"
