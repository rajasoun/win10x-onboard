#!/usr/bin/env bash

CONTAINER=mcr.microsoft.com/powershell:latest
# CONTAINER=mcr.microsoft.com/azure-powershell:latest
docker run --rm -it \
    --name "powershell-tdd" \
    -v "${PWD}:/${PWD}" \
    --workdir ${PWD} \
    $CONTAINER
    