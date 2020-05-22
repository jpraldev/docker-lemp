FROM php:fpm-alpine3.11

ARG TIMEZONE=${TIMEZONE}
ARG BUILD_WITH_GD=${BUILD_WITH_GD}
ARG BUILD_WITH_LDAP=${BUILD_WITH_LDAP}
ARG BUILD_WITH_INTL=${BUILD_WITH_INTL}

# Enable logs
RUN sed -i "s/\;php_admin_flag\[log_errors\] = on/php_admin_flag\[log_errors\] = on/g" /usr/local/etc/php-fpm.d/www.conf

# Adjusts the timezone
RUN apk add --no-cache tzdata
RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && echo $TIMEZONE > /etc/timezone
RUN echo date.timezone = "$TIMEZONE" > /usr/local/etc/php/conf.d/tzone.ini

RUN apk add --no-cache openssl curl git
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Installs mysql support
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql

# Installs modules as needed
RUN if [ ${BUILD_WITH_GD} = true ]; then \
    apk add --no-cache vim icu-dev zlib-dev libpng-dev freetype-dev && \
    docker-php-ext-configure gd --with-freetype && \
    docker-php-ext-install gd ; fi

RUN if [ ${BUILD_WITH_LDAP} = true ]; then \
    apk add --update --no-cache libldap && \
    apk add --update --no-cache --virtual .docker-php-ldap-dependancies openldap-dev && \
    docker-php-ext-configure ldap && \
    docker-php-ext-install ldap && \
    apk del .docker-php-ldap-dependancies ; fi

RUN if [ ${BUILD_WITH_INTL} = true ]; then docker-php-ext-install intl ; fi