#!/bin/bash

# Using OpenSSL provided by a Docker container for portability
docker run --rm bxggs/openssl dhparam 2048 > nginx-config-template/https_enabled/ssl-dhparams.pem
