#!/usr/bin/env sh

# We create a hosts folder if it doesn't exist yet
[ ! -d "/etc/nginx/hosts.d" ] && mkdir /etc/nginx/hosts.d && cd /etc/nginx/hosts.d 

# We generate a configuration file
CONFIG_FILE="config.txt"
BASE_DOMAIN=$2
HOSTS=$1
CUSTOM_FOLDER=/etc/nginx/custom/

cat > $CONFIG_FILE <<-EOF
server {
    listen 443 ssl http2;
    server_name {__HOST__}.$BASE_DOMAIN;
    set \$vhost {__HOST__};
    root /usr/share/nginx/html/\$vhost/public;
    index index.php index.html;
    
    include $CUSTOM_FOLDER{__HOST__}.$BASE_DOMAIN.conf;
    include fastcgi.conf;
}
EOF

# We iterate over the hosts received as a comma separated set, and create a .conf file for each one of them 
for host in $(echo $HOSTS | sed "s/,/ /g")
do
    # We include custom rules for each site if they exist, otherwise we create the empty files.
    if [ ! -f $CUSTOM_FOLDER$host.$BASE_DOMAIN.conf ] ; then touch $CUSTOM_FOLDER$host.$BASE_DOMAIN.conf; fi
    cp $CONFIG_FILE $host.conf
    sed -i s/{__HOST__}/$host/g $host.conf
done

rm $CONFIG_FILE