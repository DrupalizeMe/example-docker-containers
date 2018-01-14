#!/usr/bin/env bash

# Any background job should have it's messages printed.
set -m

# Don't continue if any command in the script fails.
set -e

# Create the lock file directory. 
mkdir -p -m 777 /var/run/mysqld/

# Define some variables, setting default values if necessary.
MYSQL_DATABASE=${MYSQL_DATABASE:-lullabot_db}
MYSQL_USERNAME=${MYSQL_USERNAME:-mysql}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-password}

# Start the MySQL server in the background.
mysqld_safe &

# Wait a moment for MySQL to fully start up.
sleep 10

# Create a database with the given name, user, and password.
mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE}"
mysql -u root -e "GRANT ALL ON ${MYSQL_DATABASE}.* to '${MYSQL_USERNAME}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}'"

# Create any additional databases if we asked for them.
if [ -n "$ADDITIONAL_DATABASES" ]; then
    for ADD_DB_NAME in $ADDITIONAL_DATABASES; do
      mysql -u root -e  "CREATE DATABASE IF NOT EXISTS $ADD_DB_NAME"
      mysql -u root -e  "GRANT ALL ON \`$ADD_DB_NAME\`.* TO '$MYSQL_USERNAME'@'%' ;"
    done;
fi

# Flush any priviledges
mysql -u root -e "FLUSH PRIVILEGES"

# Shutdown our mysql server running in the background.
mysqladmin shutdown

# Now that we're set up, run whatever command was passed to the entrypoint.
exec "$@"
