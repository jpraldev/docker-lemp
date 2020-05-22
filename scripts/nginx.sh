#!/usr/bin/env sh

# We can include any other bash scripts here, but make sure that they're added on the Dockerfile
certs.sh

exec nginx -g "daemon off;"