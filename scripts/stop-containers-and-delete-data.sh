#!/bin/bash
(
    docker-compose stop

    rm -rf \
        database \
        nginx-config \
        nginx-logs \
        webroot \
        nginx-config-template/https_enabled/ssl-dhparams.pem
)
