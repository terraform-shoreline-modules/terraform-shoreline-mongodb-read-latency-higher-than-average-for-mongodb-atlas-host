
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Read latency higher than average for MongoDB host.
---

This incident type involves an alert triggered when read latency is higher than usual for a MongoDB host. The alert is triggered when at least 100% of the average read latency values have been more than 2 deviations above the predicted values during the last 15 minutes. The incident requires monitoring and investigation to identify the root cause of the increased read latency and take appropriate actions to resolve it.

### Parameters
```shell
# Environment Variables

export MONGODB_HOSTNAME="PLACEHOLDER"

export USERNAME="PLACEHOLDER"

export MONGODB_ATLAS_PORT="PLACEHOLDER"

export PASSWORD="PLACEHOLDER"

export DATABASE_NAME="PLACEHOLDER"

export COLLECTION_NAME="PLACEHOLDER"

export CLIENT_IP="PLACEHOLDER"
```

## Debug

### 1. Check if MongoDB is running and accessible
```shell
ping ${MONGODB_HOSTNAME}
```

### 2. Check MongoDB connection status
```shell
mongo ${MONGODB_HOSTNAME}:${MONGODB_ATLAS_PORT} -u ${USERNAME} -p ${PASSWORD} --authenticationDatabase admin --eval "db.runCommand({ping:1})"
```

### 3. Check if there are any MongoDB operations currently running
```shell
mongo ${MONGODB_HOSTNAME}:${MONGODB_ATLAS_PORT} -u ${USERNAME} -p ${PASSWORD} --authenticationDatabase admin --eval "db.currentOp()"
```

### 4. Check MongoDB latency
```shell
mongostat --host ${MONGODB_HOSTNAME} --port ${MONGODB_ATLAS_PORT}
```

### 5. Check the status of MongoDB indexes
```shell
mongo ${MONGODB_HOSTNAME}:${MONGODB_ATLAS_PORT}/${DATABASE_NAME} -u ${USERNAME} -p ${PASSWORD} --authenticationDatabase admin --eval "db.${COLLECTION_NAME}.getIndexes()"
```

### 6. Check MongoDB disk usage
```shell
mongo ${MONGODB_HOSTNAME}:${MONGODB_ATLAS_PORT}/${DATABASE_NAME} -u ${USERNAME} -p ${PASSWORD} --authenticationDatabase admin --eval "db.stats()"
```
### 7. Check the read latency for the MongoDB host
```shell
mongo ${MONGODB_HOSTNAME}:${MONGODB_ATLAS_PORT}/${DATABASE_NAME} -u ${USERNAME} -p ${PASSWORD} --authenticationDatabase admin --eval "db.currentOp({'secs_running': {$gte: 1}}).inprog.forEach(function(op) { printjson(op.opid + ': ' + op.secs_running + 'secs'); });"

### Network latency issues between the MongoDB host and the client.
```shell
#!/bin/bash
# Define the MongoDB host and client IP addresses

MONGODB_HOST=${MONGODB_HOSTNAME}

CLIENT_IP=${CLIENT_IP}

# Check if the MongoDB host is reachable from the client

ping -c 3 $MONGODB_HOST > /dev/null

if [ $? -eq 0 ]; then

    echo "MongoDB host is reachable from the client."

else

    echo "MongoDB host is not reachable from the client."

fi

# Check the network latency between the MongoDB host and the client

ping -c 3 $MONGODB_HOST | tail -1| awk '{print $4}' | cut -d '/' -f 2 > /dev/null

if [ $? -eq 0 ]; then

    latency=$(ping -c 3 $MONGODB_HOST | tail -1| awk '{print $4}' | cut -d '/' -f 2)

    echo "Network latency between the MongoDB host and the client is $latency ms."

else

    echo "Unable to determine network latency between the MongoDB host and the client."

fi

```

## Repair

### Optimize the MongoDB configuration settings to reduce read latency.
```shell
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


```