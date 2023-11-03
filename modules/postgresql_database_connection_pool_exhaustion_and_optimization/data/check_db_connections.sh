

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