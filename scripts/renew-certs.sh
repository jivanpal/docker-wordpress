#!/bin/bash
(
    source .env

    docker run -it --rm \
        -v "$(pwd)/letsencrypt:/etc/letsencrypt" \
        -v "$(pwd)/nginx-config:/etc/nginx/conf.d" \
        certbot/dns-digitalocean \
            certonly \
            --register-unsafely-without-email \
            --agree-tos \
            --dns-digitalocean \
            --dns-digitalocean-credentials /etc/nginx/conf.d/digitalocean.ini \
            -d ${DOMAIN_NAME}
)
