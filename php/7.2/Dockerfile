FROM ubuntu:bionic

################################################################################
#                                                                              #
#   THIS CONTAINER IS FOR EDUCATIONAL USE ONLY!                                #
#                                                                              #
#   Never use this container for running production workloads!                 #
#                                                                              #
################################################################################

# Update the package manager...
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update

# ...then install packages.
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -yq \
    apache2 \
    php7.2 \
    libapache2-mod-php7.2 \
    php7.2-mysql \
    php7.2-cli \
    php7.2-common \
    php7.2-gd \
    php7.2-mbstring \
    php7.2-xml \
    php7.2-opcache \
    php7.2-sqlite3 \
    php7.2-mysql \
    php7.2-curl \
    php7.2-soap \
    mariadb-client \
    curl \
    git \
    vim \
    zip

# Replace configuration files with our own.
COPY apache2.conf /etc/apache2/apache2.conf
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY php_apache2.ini /etc/php/7.2/apache2/php.ini
COPY php_cli.ini /etc/php/7.2/cli/php.ini
COPY php-conf /etc/php/7.2/mods-available

# Enable mod_rewrite 'cause we needs it.
RUN a2enmod rewrite

# Forward logs to docker log collector.
RUN ln -sf /dev/stdout /var/log/apache2/access.log && \
    ln -sf /dev/stderr /var/log/apache2/error.log && \
    ln -sf /dev/stdout /var/log/apache2/000_default-access_log && \
    ln -sf /dev/stderr /var/log/apache2/000_default-error_log

# Copy our custom entrypoint and make it executable.
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# Expose the default Apache port.
EXPOSE 80

# Replace the standard entrypoint /bin/sh with our script.
ENTRYPOINT ["docker-entrypoint.sh"]

# If no command is passed to the container, start Apache by default.
CMD ["apachectl", "-D", "FOREGROUND"]
