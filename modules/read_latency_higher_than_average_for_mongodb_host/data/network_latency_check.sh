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