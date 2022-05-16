#!/bin/bash

## This script builds and pushes the latest build of each version of velocity

# Build Velocity
versions=$(curl -s 'https://papermc.io/api/v2/projects/velocity' | jq -r ".version_groups[]")

for version in $versions; do
    build=$(curl -s "https://papermc.io/api/v2/projects/velocity/version_group/${version}/builds" | jq .builds[-1])

    version=$(jq -r '.version' <<< "$build")
    build_id=$(jq -r '.build' <<< "$build")

    echo "Building Velocity $version build $build_id"

    docker build \
        --build-arg VELOCITY_VERSION="$version" \
        --build-arg=BUILD_NUMBER="$build_id" \
        -t "port3m5/velocity" \
        -t "port3m5/velocity:${version}" \
        -t "port3m5/velocity:${version}-${build_id}" \
        velocity

    docker push "port3m5/velocity:${version}"
    docker push "port3m5/velocity:${version}-${build_id}"
done;

docker push "port3m5/velocity"