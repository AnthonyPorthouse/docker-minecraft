#!/bin/bash
set -e

if [ ! -f eula.txt ]; then
    echo "Accepting Minecraft EULA"
    echo "eula=true" > eula.txt
fi

JAVA_PARAMS=("$JAVA_PARAMS")

java -server -Xms"${MIN_RAM}" -Xmx"${MAX_RAM}" ${JAVA_PARAMS[@]} -jar /opt/server.jar nogui