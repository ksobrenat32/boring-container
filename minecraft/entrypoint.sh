#!/usr/bin/env bash
set -eo pipefail

# Running command.
JAVA_PATH="/usr/bin/java"
CMD="${JAVA_PATH} -Xmx${XMX} -Xms${XMS} -jar /data/${SERVER_JAR} nogui"

if [[ -z "$(ls -A /data)" ]]; then

    echo '
|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|
|      No minecraft world detected      |
|            Generating one             |
|_______________________________________|
'

    # VERSION
    if [[ -z "${SERVER_VERSION}" ]] || [[ "${SERVER_VERSION}" == "LATEST" ]] ; then
        VERSION=$(curl -fsSL "https://launchermeta.mojang.com/mc/game/version_manifest.json" | jq -r '.latest.release')
        echo "Latest version selected by default, this is ${VERSION}"
    else 
        VERSION=${SERVER_VERSION}
        echo "Trying with your selected version, this is ${VERSION}"
    fi

    # SERVER_TYPE
    case "$SERVER_TYPE" in
        PAPER)
            echo "Going with the Paper server and Bedrock plugins"
            # Minecraft
            PAPER_VERSION=$(curl -fsSL "https://papermc.io/api/v2/projects/paper/versions/${VERSION}" | jq '.builds[-1]')
            SERVER_DOWNLOAD_URL="https://papermc.io/api/v2/projects/paper/versions/${VERSION}/builds/${PAPER_VERSION}/downloads/paper-${VERSION}-${PAPER_VERSION}.jar"

            # Plugins
            mkdir -p /data/plugins
    curl -fsSL "https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/spigot/target/Geyser-Spigot.jar" -o /data/plugins/Geyser-Spigot.jar
    curl -fsSL "https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/spigot/target/floodgate-spigot.jar" -o /data/plugins/floodgate-spigot.jar
            mkdir -p /data/plugins/Geyser-Spigot
            mv /opt/mc/Geyser/config.yml /data/plugins/Geyser-Spigot/config.yml
            ;;

        VANILLA)
            echo "Going with the Vanilla server"
            VERSION_JSON=$(curl -fsSL "https://launchermeta.mojang.com/mc/game/version_manifest.json" | jq -r --arg VERSION_TARGET "${VERSION}" '.versions | .[] | select(.id==$VERSION_TARGET) | .url')
            SERVER_DOWNLOAD_URL=$(curl -fsSL "${VERSION_JSON}" | jq -r '.downloads.server.url')
            ;;
        *)
            echo "Select a valid server type, exiting ..."
            exit 127
            ;;
    esac

    # Download server
    echo "
    Downloading ${SERVER_TYPE} server, version ${VERSION} ...
    URL =  ${SERVER_DOWNLOAD_URL}
    "
    curl -fsSL ${SERVER_DOWNLOAD_URL} -o /data/server.jar

    # Accept EULA
    echo "eula=true" >> /data/eula.txt

    # Try running
    echo "
Trying to start the minecraft server running:
${CMD}
"

else
    echo "
Trying to start the minecraft server running:
${CMD}
"
fi

# Run the command.
${CMD}
