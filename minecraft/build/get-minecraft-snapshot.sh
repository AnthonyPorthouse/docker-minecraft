#!/bin/bash

if ! command -v jq >/dev/null 2>&1; then
    echo "jq is missing";
    exit 1
fi

manifest=$(curl -s 'https://launchermeta.mojang.com/mc/game/version_manifest.json')

latest_version=$(jq -r '.latest.snapshot' <<< "$manifest")
versions=$(jq -c '[[.versions[] | select( .type == "snapshot" )][0]]' <<< "$manifest")

echo "::set-output name=latest::$latest_version"
echo "::set-output name=versions::$versions"