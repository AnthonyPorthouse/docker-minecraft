#!/bin/bash

if ! command -v jq >/dev/null 2>&1; then
    echo "jq is missing";
    exit 1
fi

manifest=$(curl -s 'https://papermc.io/api/v2/projects/paper')

versions=$(jq -c '.version_groups' <<< "$manifest")
latest_version=$(jq -r '.version_groups[-1]' <<< "$manifest")

echo "::set-output name=latest::$latest_version"
echo "::set-output name=versions::$versions"