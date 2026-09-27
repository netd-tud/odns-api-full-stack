#!/bin/bash

docker compose -f docker-compose.yml \
    -f docker-compose.db.yml \
    -f docker-compose.emailer.yml up -d