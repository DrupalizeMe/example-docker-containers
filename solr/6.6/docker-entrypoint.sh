#!/usr/bin/env bash

# Any background job should have it's messages printed.
set -m

# Don't continue if any command in the script fails.
set -e

SOLR_HOME="${SOLR_HOME:-/opt/solr/server/solr}"

# Set a default core name if one isn't provided.
SOLR_CORE_NAME=${SOLR_CORE_NAME:-search_api_core}

# Generate the core directory given the name.
CORE_DIR="${SOLR_HOME}/${SOLR_CORE_NAME}"

if [[ -d $CORE_DIR ]]; then
    echo "$CORE_DIR exists; skipping core creation"
else
  # Start Solr in the background so we can create a new core.
  # Note, this is provided by the container's base image, not Solr.
  start-local-solr

  # Create the core directory, and copy over the Search API scheama.
  mkdir -p -m 775 $CORE_DIR/conf
  mkdir -p -m 775 $CORE_DIR/data
  rsync -a /opt/search_api_solr/solr-conf/6.x/ $CORE_DIR/conf

  echo "Creating Search API Solr core: $SOLR_CORE_NAME"
  /opt/solr/bin/solr create -c $SOLR_CORE_NAME

  # Stop the background Solr now that we're finished creating the core.
  # Again, this utility is provided by the container's base image.
  stop-local-solr
fi

exec "$@"
