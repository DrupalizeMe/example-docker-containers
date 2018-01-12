FROM ubuntu:xenial

# Update the package manager, then install MariaDB server.
RUN apt-get update && apt-get install -y mariadb-server=10.0.31-0ubuntu0.16.04.2

# Reconfigure the bind address of MySQL to allow any incoming network connection.
RUN sed -i -e "s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

# Copy our custom entrypoint and make it executable.
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Mark the MySQL directory as a volume.
VOLUME /var/lib/mysql

# Expose the default MySQL port.
EXPOSE 3306

# Replace the standard entrypoint /bin/sh with our script.
ENTRYPOINT ["docker-entrypoint.sh"]

# If no command is passed to the container, start the MySQL server by default.
CMD ["/usr/bin/mysqld_safe"]

