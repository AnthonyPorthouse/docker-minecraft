#!/bin/bash

if ! command -v jq >/dev/null 2>&1; then
    echo "jq is missing" > /dev/stderr
    exit 1
fi

version="${VERSION:-}"

minecraft_version=$(jq -r '.id' <<< "$version")

url=$(jq -r '.url' <<< "$version")

data=$(curl -s "$url")

java_version=$(jq -r '.javaVersion.majorVersion' <<< "$data")
if [ "$java_version" == "null" ]; then
    java_version="8"
fi
server_url=$(jq -r '.downloads.server.url' <<< "$data")

if [ "$server_url" == "null" ]; then
    echo "Release has no server defined, skipping" > /dev/stderr
    exit 0
fi

echo "::set-output name=minecraft_version::$minecraft_version"
echo "::set-output name=server_url::$server_url"
echo "::set-output name=java_version::$java_version"
