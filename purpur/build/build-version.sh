#!/bin/bash

if ! command -v jq >/dev/null 2>&1; then
    echo "jq is missing" > /dev/stderr
    exit 1
fi

latest="${LATEST_VERSION:-}"
version="${VERSION:-}"

IMAGE_NAME=${IMAGE_NAME:-port3m5/purpur}
IMAGE_NAME=$(echo "$IMAGE_NAME" | tr '[:upper:]' '[:lower:]')

build=$(curl -s "https://api.purpurmc.org/v2/purpur/${version}" | jq -r '.builds.latest')

minecraft_version="$version"
build_id="$build"

echo "Building Purpur $minecraft_version build $build_id"

docker build \
    --build-arg MINECRAFT_VERSION="$minecraft_version" \
    --build-arg=BUILD_NUMBER="$build_id" \
    -t "$IMAGE_NAME" \
    -t "$IMAGE_NAME:${minecraft_version}" \
    -t "$IMAGE_NAME:${minecraft_version}-${build_id}" \
    purpur

docker push "$IMAGE_NAME:${minecraft_version}"
docker push "$IMAGE_NAME:${minecraft_version}-${build_id}"

if [ "$version" == "$latest" ]; then
    docker push "$IMAGE_NAME"
fi