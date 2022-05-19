ARG JAVA_IMAGE=eclipse-temurin:18-alpine

FROM alpine as build

ARG MINECRAFT_VERSION
ARG BUILD_NUMBER

WORKDIR /app

RUN echo "Getting Purpur ${MINECRAFT_VERSION} build ${BUILD_NUMBER}" \
    && apk add --no-cache curl \
    && curl -Lo purpur.jar https://api.purpurmc.org/v2/purpur/${MINECRAFT_VERSION}/${BUILD_NUMBER}/download

FROM ${JAVA_IMAGE}

EXPOSE 25565

WORKDIR /app

ENV MIN_RAM="512M"
ENV MAX_RAM="2048M"
ENV JAVA_PARAMS="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1"

RUN apk add --no-cache bash

COPY --from=build /app/purpur.jar /opt/purpur.jar
COPY ./entrypoint.sh /entrypoint.sh

VOLUME [ "/app" ]

ENTRYPOINT [ "/entrypoint.sh" ]