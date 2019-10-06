#!/bin/bash

source .env

docker rm ${CONTAINER_PREFIX}_{database,wordpress,webserver}
docker network rm "$(basename $(pwd))_default"
