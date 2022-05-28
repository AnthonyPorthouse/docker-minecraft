#!/bin/bash

if ! command -v jq >/dev/null 2>&1; then
    echo "jq is missing" > /dev/stderr
    exit 1
fi

version="${VERSION:-}"

build=$(curl -s "https://papermc.io/api/v2/projects/paper/version_group/${version}/builds" | jq .builds[-1])

minecraft_version=$(jq -r '.version' <<< "$build")
build_id=$(jq -r '.build' <<< "$build")

echo "::set-output name=minecraft-version::${minecraft_version}"
echo "::set-output name=build-id::${build_id}"
echo "::set-output name=version::${minecraft_version}-${build_id}"
