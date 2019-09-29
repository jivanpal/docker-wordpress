#!/bin/bash
(
    source .env

    rm -rf nginx-config
    mkdir nginx-config
    cp nginx-config-template/main.conf.include nginx-config/

# Perform environment variable substitution, placing
# processed files in actual `nginx-config` directory

    docker run --rm \
        --env-file .env \
        -v "$(pwd)/nginx-config-template/https_${HTTPS}:/workdir" \
        -v "$(pwd)/nginx-config:/processed" \
        dibi/envsubst

# Set permissions on file containing DigitalOcean API key
# so that Certbot doesn't complain about security concerns

    if [ -f nginx-config/digitalocean.ini ]; then
        chmod 600 nginx-config/digitalocean.ini
    fi
)
