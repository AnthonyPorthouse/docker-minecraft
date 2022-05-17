#!/bin/bash

if ! command -v jq >/dev/null 2>&1; then
    echo "jq is missing" > /dev/stderr
    exit 1
fi

latest="${LATEST_VERSION:-}"
version="${VERSION:-}"

IMAGE_NAME=${IMAGE_NAME:-port3m5/paper}
IMAGE_NAME=$(echo "$IMAGE_NAME" | tr '[:upper:]' '[:lower:]')

build=$(curl -s "https://papermc.io/api/v2/projects/paper/version_group/${version}/builds" | jq .builds[-1])

version=$(jq -r '.version' <<< "$build")
build_id=$(jq -r '.build' <<< "$build")

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

if [ "$version" == "$latest" ]; then
    docker push "$IMAGE_NAME"
fi