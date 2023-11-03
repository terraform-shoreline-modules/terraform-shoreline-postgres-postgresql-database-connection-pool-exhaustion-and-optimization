
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# PostgreSQL database connection pool exhaustion and optimization
---

This incident type refers to the situation where a PostgreSQL application experiences database connection pool exhaustion, leading to errors. This can happen when the number of database connections requested exceeds the maximum number of connections allowed in the pool. To prevent this issue, it is important to optimize database connections by properly configuring the connection pool settings and monitoring the usage of connections. This can help ensure that the application has sufficient resources to handle database requests without experiencing pool exhaustion.

### Parameters
```shell
export USERNAME="PLACEHOLDER"

export DATABASE_NAME="PLACEHOLDER"

export DATABASE_PORT="PLACEHOLDER"

export MAXIMUM_NUMBER_OF_CONNECTIONS="PLACEHOLDER"

export DATABASE_HOST="PLACEHOLDER"

export PATH_TO_CONFIG_FILE="PLACEHOLDER"

export NEW_MAXIMUM_CONNECTION_LIMIT="PLACEHOLDER"

export APPLICATION_NAME="PLACEHOLDER"
```

## Debug

### Check the current size of the PostgreSQL connection pool
```shell
sudo -u postgres psql -c "SELECT COUNT(*) FROM pg_stat_activity WHERE datname = '${DATABASE_NAME}' AND usename = '${USERNAME}'"
```

### Identify the maximum number of PostgreSQL connections allowed in the connection pool
```shell
sudo -u postgres psql -c "SHOW max_connections"
```

### Check the current number of open file descriptors on the system
```shell
ulimit -n
```

### Identify the number of connections allowed per client IP address
```shell
sudo -u postgres psql -c "SHOW max_connections_per_ip"
```

### Check the current number of idle connections in the PostgreSQL pool
```shell
sudo -u postgres psql -c "SELECT COUNT(*) FROM pg_stat_activity WHERE datname = '${DATABASE_NAME}' AND usename = '${USERNAME}' AND state = 'idle'"
```

### Check the current number of active connections in the PostgreSQL pool
```shell
sudo -u postgres psql -c "SELECT COUNT(*) FROM pg_stat_activity WHERE datname = '${DATABASE_NAME}' AND usename = '${USERNAME}' AND state = 'active'"
```

### The maximum number of connections allowed in the pool is set too low, leading to contention for available connections and eventual pool exhaustion.
```shell


#!/bin/bash



# Set the maximum number of connections allowed in the pool

MAX_CONNECTIONS=${MAXIMUM_NUMBER_OF_CONNECTIONS}



# Check the current number of connections in the pool

CURRENT_CONNECTIONS=$(psql -U ${USERNAME} -h ${DATABASE_HOST} -p ${DATABASE_PORT} -c "SELECT count(*) FROM pg_stat_activity WHERE datname = '${DATABASE_NAME}';" | grep -o '[0-9]\+')



# Check if the current number of connections is close to the maximum limit

if [ $CURRENT_CONNECTIONS -ge $((MAX_CONNECTIONS - 10)) ]; then

  echo "Warning: The current number of connections ($CURRENT_CONNECTIONS) is close to the maximum limit ($MAX_CONNECTIONS)."

else

  echo "OK: The current number of connections ($CURRENT_CONNECTIONS) is within the acceptable range."

fi


```

## Repair

### Increase the maximum number of connections allowed in the connection pool. This can be done by editing the configuration file of the application and adjusting the connection pool settings.
```shell


#!/bin/bash



# Set the path to the configuration file

CONFIG_FILE=${PATH_TO_CONFIG_FILE}



# Set the new maximum connection limit

NEW_LIMIT=${NEW_MAXIMUM_CONNECTION_LIMIT}



# Update the configuration file with the new limit

sed -i "s/max_connections = [0-9]\+/max_connections = $NEW_LIMIT/" $CONFIG_FILE



# Restart the application to apply the changes

systemctl restart ${APPLICATION_NAME}


```