#!/bin/bash

docker compose -f docker-compose.yml \
    -f docker-compose.db.yml \
    -f docker-compose.api.yml \
    -f docker-compose.importer.yml \
    -f docker-compose.web.yml \
    -f docker-compose.observability.yml up -d