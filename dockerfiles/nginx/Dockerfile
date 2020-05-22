FROM nginx:alpine

ARG HOSTS=${HOSTS}
ARG TIMEZONE=${TIMEZONE}
ARG BASE_DOMAIN=${BASE_DOMAIN}

# Adjusts the timezone
RUN apk add --no-cache tzdata
RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && echo $TIMEZONE > /etc/timezone

RUN apk add --no-cache openssl

# Generates the server files to be included by nginx.conf for each host defined on the .env file
COPY scripts/hosts.sh /usr/local/bin/
COPY conf/custom/* /etc/nginx/custom/
RUN hosts.sh $HOSTS $BASE_DOMAIN

# Main and fastcgi nginx config files
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/fastcgi.conf /etc/nginx/fastcgi.conf

# It generates the SSL certificates for ${BASE_DOMAIN} if not present on /certs
COPY scripts/certs.sh /usr/local/bin/

# Execute any scripts included and starts nginx on the foreground at the end
COPY scripts/nginx.sh /usr/local/bin/

WORKDIR /etc/nginx/certs/

ENTRYPOINT ["nginx.sh"]