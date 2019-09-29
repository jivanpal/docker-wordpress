#!/bin/bash
(
    source .env

    if [[ ${HTTPS} = enabled ]]; then
        ./scripts/regenerate-dhparams.sh
        ./scripts/renew-certs.sh
    fi

    ./scripts/regenerate-nginx-config.sh
)
