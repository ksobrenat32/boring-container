#!/bin/sh
set -euo pipefail

# Running command.
CMD="/usr/bin/java -Xmx${XMX} -Xms${XMS} -jar /data/${SERVER_JAR} nogui"

if [ -z "$(ls -A /data)" ]; then
    echo 
    echo 'Downloading a new minecraft server'
    echo "${CMD}"
    echo

    # Make sure to install needed tools
    apt-get install -y -qq jq gawk curl coreutils sed

    # Getting the latest minecraft and paper version
    LATEST_VERSION=$(curl -fsSL "https://launchermeta.mojang.com/mc/game/version_manifest.json" -H  "accept: application/json" | awk '{print $3}' | sed 's/\"//g' | sed 's/\,//g')
    PAPER_VERSION=$(curl -fsSL "https://papermc.io/api/v2/projects/paper/versions/${LATEST_VERSION}" -H  "accept: application/json" | jq '.builds[-1]')
    PAPER_URL="https://papermc.io/api/v2/projects/paper/versions/${LATEST_VERSION}/builds/${PAPER_VERSION}/downloads/paper-${LATEST_VERSION}-${PAPER_VERSION}.jar"

    # Downloading files
    curl -fsSL ${PAPER_URL} -o /data/server.jar
    curl -fsSL https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/spigot/target/Geyser-Spigot.jar -O /data/plugins/Geyser-Spigot.jar
    curl -fsSL https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/spigot/target/floodgate-spigot.jar -O /data/plugins/floodgate-spigot.jar

    # Generate configurations
    echo "eula=true" >> /data/eula.txt
    timeout 1m /usr/bin/java -jar /data/${SERVER_JAR} nogui
    sed -i -e "s/  server-name: \"Geyser\"/  server-name: \"Minecraft Server\"/" /data/plugins/Geyser-Spigot/config.yml
    sed -i -e "s/  motd1: \"Geyser\"/  motd1: \"Minecraft Server\"/" /data/plugins/Geyser-Spigot/config.yml
    sed -i -e "s/  motd2: \"Another Geyser server.\"/  motd2: \"Minecraft Server\"/" /data/plugins/Geyser-Spigot/config.yml
    sed -i -e "s/  auth-type: online/  auth-type: floodgate/" /data/plugins/Geyser-Spigot/config.yml

    # Try running
    echo 
    echo 'Trying to start the minecraft server running:'
    echo "${CMD}"
    echo

else
    echo 
    echo 'Trying to start the minecraft server running'
    echo "${CMD}"
    echo
fi

# Run the command.
${CMD}
