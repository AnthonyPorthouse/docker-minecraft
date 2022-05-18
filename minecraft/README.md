# ghcr.io/anthonyporthouse/docker-minecraft/minecraft

[![minecraft-parallel](https://github.com/AnthonyPorthouse/docker-minecraft/actions/workflows/minecraft-parallel.yaml/badge.svg)](https://github.com/AnthonyPorthouse/docker-minecraft/actions/workflows/minecraft-parallel.yaml)

## Example Usage

To run a server in the current directory and expose the server on the default minecraft port of `25566` you can run the following command:

`docker run -ti -p 25566:25566 -v $(pwd):/app ghcr.io/anthonyporthouse/docker-minecraft/minecraft`

The server can be futher customized with environment variables as defined below.

## Environment Variables

- `MIN_RAM` - Sets the starting amount of ram for java to use. Defaults to `512M`
- `MAX_RAM` - Sets the maximum amount of ram for java to use. Defaults to `2048M`
- `JAVA_PARAMS` - Sets additional java parameters for the server. Defaults to `-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1` (See [Aikar's Flags](https://aikar.co/mcflags.html))
