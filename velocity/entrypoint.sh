#!/bin/bash
set -e

JAVA_PARAMS=("$JAVA_PARAMS")

java -server -Xms"${MIN_RAM}" -Xmx"${MAX_RAM}" ${JAVA_PARAMS[@]} -jar /opt/velocity.jar nogui