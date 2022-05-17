#!/bin/bash

if ! command -v jq >/dev/null 2>&1; then
    echo "jq is missing";
    exit 1
fi

manifest=$(curl -s 'https://maven.fabricmc.net/net/fabricmc/fabric-installer/maven-metadata.xml')

latest_version=$(jq -r '.latest.release' <<< "$manifest")
versions=$(jq -c '[.versions[] | select( .type == "release" )]' <<< "$manifest")

echo "::set-output name=latest::$latest_version"
echo "::set-output name=versions::$versions"