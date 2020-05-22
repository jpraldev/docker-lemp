#!/usr/bin/env sh

if [ -z "$(ls -A .)" ]; then

# Set the TLD domain we want to use
BASE_DOMAIN=$BASE_DOMAIN
# Days for the cert to live
DAYS=1095

# A blank passphrase
PASSPHRASE=""

# Generated configuration file
CONFIG_FILE="config.txt"

cat > $CONFIG_FILE <<-EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
x509_extensions = v3_req
distinguished_name = dn

[dn]
C = GB
ST = EN
L = Barcelona
O = Inclusive Digital
OU = $BASE_DOMAIN
emailAddress = web.development@$BASE_DOMAIN
CN = $BASE_DOMAIN

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = *.$BASE_DOMAIN
DNS.2 = $BASE_DOMAIN
EOF

FILE_NAME="ssl-cert"

echo "Generating certs for $BASE_DOMAIN"

# Generate our Private Key, CSR and Certificate
openssl req -new -x509 -newkey rsa:2048 -sha256 -nodes -keyout "$FILE_NAME.key" -days $DAYS -out "$FILE_NAME.crt" -passin pass:$PASSPHRASE -config "$CONFIG_FILE"

rm $CONFIG_FILE
fi