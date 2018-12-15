FROM solr:6.6

################################################################################
#                                                                              #
#   THIS CONTAINER IS FOR EDUCATIONAL USE ONLY!                                #
#                                                                              #
#   Never use this container for running production workloads!                 #
#                                                                              #
################################################################################

# The base image switches to the Solr user, so we switch to root to tweak it.
USER root

# Update the package manager, then install packages.
RUN apt-get update && \
    apt-get install -y \
    rsync

# Download and extract Search API Solr.
ADD https://ftp.drupal.org/files/projects/search_api_solr-8.x-2.3.tar.gz /opt/search_api_solr.tar.gz
RUN tar -xzf /opt/search_api_solr.tar.gz -C /opt/

# Copy our custom entrypoint and make it executable.
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Now that we're done building, switch back to the Solr user.
USER $SOLR_USER

# Expose the default Solr port.
EXPOSE 8983

# Replace base images' entrypoint with our script.
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# If no command is passed to the container, start Solr by default.
CMD ["solr-foreground"]
