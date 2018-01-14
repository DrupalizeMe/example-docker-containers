#!/usr/bin/env bash

# Any background job should have it's messages printed.
set -m

# Don't continue if any command in the script fails.
set -e

# Allow the Apache docroot to be overridden.
APACHE_DOCROOT_DIR="${APACHE_DOCROOT_DIR:-/var/www/html}"
if [ -n "$APACHE_DOCROOT_DIR" ]; then
     sed -i 's@^\s*DocumentRoot.*@'"        DocumentRoot ${APACHE_DOCROOT_DIR}"'@'  /etc/apache2/sites-available/000-default.conf
fi

# Allow the site name to be overriden.
APACHE_SITE_NAME="${APACHE_SITE_NAME:-docker.test}"
if [ -n "$APACHE_SITE_NAME" ]; then
     sed -i 's@^\s*ServerName.*@'"        ServerName ${APACHE_SITE_NAME}"'@'  /etc/apache2/sites-available/000-default.conf
fi

# Allow for site aliases to be provided.
APACHE_SITE_ALIAS="${APACHE_SITE_ALIAS:-docker.localhost}"
if [ -n "$APACHE_SITE_ALIAS" ]; then
     sed -i 's@^\s*ServerAlias.*@'"        ServerAlias ${APACHE_SITE_ALIAS}"'@'  /etc/apache2/sites-available/000-default.conf
fi

# Now that we're set up, run whatever command was passed to the entrypoint.
exec "$@"
