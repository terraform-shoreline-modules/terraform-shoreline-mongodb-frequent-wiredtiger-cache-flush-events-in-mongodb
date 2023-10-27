
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Frequent WiredTiger Cache Flush Events in MongoDB.
---

This incident type refers to the occurrence of frequent cache flush events in MongoDB's WiredTiger storage engine. WiredTiger is a modern storage engine used by MongoDB to provide scalability and high performance. However, any issue with the cache can lead to a significant impact on the performance of the database and the applications running on it. A cache flush event is a mechanism by which the data stored in the cache is written back to the disk. Frequent cache flush events indicate that the cache is not able to store the required data and is frequently getting full. This can lead to performance issues and can affect the overall functionality of the database.

### Parameters
```shell
export MONGODB_LOG_FILE="PLACEHOLDER"

export COLLECTION_NAME="PLACEHOLDER"

export DATABASE_NAME="PLACEHOLDER"

export PATH_TO_WIREDTIGER_CONFIG_FILE="PLACEHOLDER"

export NEW_CACHE_SIZE="PLACEHOLDER"
```

## Debug

### Identify the MongoDB server process ID
```shell
ps aux | grep mongod
```

### Check the MongoDB server log for errors or warnings related to WiredTiger
```shell
tail ${MONGODB_LOG_FILE}
```

### Check the WiredTiger cache utilization
```shell
mongostat --all -n 1
```

### Check the WiredTiger cache statistics
```shell
mongo --eval "printjson(db.serverStatus().wiredTiger.cache)"
```

### Check the MongoDB database statistics
```shell
mongo --eval "printjson(db.stats())"
```

### Check the MongoDB collection statistics
```shell
mongo ${DATABASE_NAME} --eval "printjson(db.${COLLECTION_NAME}.stats())"
```

### Check the indexes on the MongoDB collection
```shell
mongo ${DATABASE_NAME} --eval "printjson(db.${COLLECTION_NAME}.getIndexes())"
```

## Repair

### Increase the cache size to reduce the frequency of cache flushes
```shell
bash

#!/bin/bash



# Set the path to the WiredTiger configuration file

WT_CONFIG_FILE=${PATH_TO_WIREDTIGER_CONFIG_FILE}



# Set the new cache size

NEW_CACHE_SIZE=${NEW_CACHE_SIZE}



# Update the WiredTiger configuration file with the new cache size

sed -i "s/cache_size=.*M/cache_size=${NEW_CACHE_SIZE}M/g" ${WT_CONFIG_FILE}



# Restart the MongoDB service to apply the new configuration

systemctl restart mongod.service


```