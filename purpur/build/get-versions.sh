#!/bin/bash

if ! command -v jq >/dev/null 2>&1; then
    echo "jq is missing";
    exit 1
fi

manifest=$(curl -s 'https://api.purpurmc.org/v2/purpur')

versions=$(jq -c '.versions' <<< "$manifest")
latest_version=$(jq -r '.versions[-1]' <<< "$manifest")

echo "::set-output name=latest::$latest_version"
echo "::set-output name=versions::$versions"