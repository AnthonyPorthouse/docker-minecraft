#!/bin/bash

if ! command -v jq >/dev/null 2>&1; then
    echo "jq is missing";
    exit 1
fi

IMAGE_NAME=${IMAGE_NAME:-port3m5/minecraft}
IMAGE_NAME=$(echo "$IMAGE_NAME" | tr '[:upper:]' '[:lower:]')

manifest=$(curl -s 'https://launchermeta.mojang.com/mc/game/version_manifest.json')

latest_version=$(jq -r '.latest.release' <<< "$manifest")
versions=$(jq -c '[.versions[] | select( .type == "release" )]' <<< "$manifest")

echo "::set-output name=latest::$latest_version"
echo "::set-output name=versions::$versions"