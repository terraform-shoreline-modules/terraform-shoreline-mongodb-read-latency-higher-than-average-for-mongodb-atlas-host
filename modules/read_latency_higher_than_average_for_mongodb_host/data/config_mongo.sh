#!/bin/bash

# Define the MongoDB configuration file path

CONFIG_FILE="/etc/mongod.conf"

# Set the read concern level to "majority"

sed -i 's/readConcernLevel.*/readConcernLevel: majority/g' $CONFIG_FILE

# Increase the number of connections allowed to the database

sed -i 's/maxConnectionsPerHost.*/maxConnectionsPerHost: 100/g' $CONFIG_FILE

# Enable the query optimizer

sed -i 's/enableLocalhostAuthBypass.*/enableLocalhostAuthBypass: true/g' $CONFIG_FILE

# Restart the MongoDB service to apply the changes

systemctl restart mongodb.service