#!/bin/sh

# Prepare the command.
CMD="java -Xmx${XMX} -Xms${XMS} -jar /data/${SERVER_JAR} nogui"

# Output the command to the logs.
echo "
Trying to start the minecraft server running
${CMD}
"

# Run the command.
${CMD}
