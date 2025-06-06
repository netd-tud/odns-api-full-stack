#!/bin/bash

docker compose -f docker-compose.api.yml \
    -f docker-compose.importer.yml down

# stop db and remove volume with data
docker compose -f docker-compose.db.yml down -v
#docker volume rm odns-api-full-stack_postgres_data

# Restart service stoped above
docker compose -f docker-compose.yml \
    -f docker-compose.db.yml \
    -f docker-compose.api.yml \
    -f docker-compose.importer.yml up -d
