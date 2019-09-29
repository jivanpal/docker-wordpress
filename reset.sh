#!/bin/bash
(
    ./scripts/stop-containers-and-delete-data.sh
    ./scripts/destroy-containers.sh
)
