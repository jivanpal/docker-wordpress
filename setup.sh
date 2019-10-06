#!/bin/bash

source .env

if [ $HTTPS = "enabled" ]; then
    ./scripts/regenerate-dhparams.sh
fi

./scripts/regenerate-nginx-config.sh

if [ $HTTPS = "enabled" ]; then
    ./scripts/renew-certs.sh
fi
