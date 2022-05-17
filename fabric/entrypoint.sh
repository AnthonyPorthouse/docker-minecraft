#!/bin/bash
set -e

if [ ! -f eula.txt ]; then
    echo "Accepting Minecraft EULA"
    echo "eula=true" > eula.txt
fi

if [ ! -f "fabric-server-launch.jar" ]; then
    FABRIC_PARAMS=(-downloadMinecraft -noprofile)
    if [ "$SNAPSHOT" != "" ]; then
        FABRIC_PARAMS+=(-snapshot)
    fi

    if [ "$MINECRAFT_VERSION" != "" ]; then
        FABRIC_PARAMS+=("-mcversion $MINECRAFT_VERSION")
    fi

    JAVA_PARAMS=("$JAVA_PARAMS")

    java \
        -jar /opt/fabric-installer.jar \
        server \
        ${FABRIC_PARAMS[@]}
fi

JAVA_PARAMS=("$JAVA_PARAMS")

java -server -Xms"${MIN_RAM}" -Xmx"${MAX_RAM}" ${JAVA_PARAMS[@]} -jar /app/fabric-server-launch.jar nogui
