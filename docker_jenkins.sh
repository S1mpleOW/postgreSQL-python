#!/bin/bash
APP_PORT=8000

docker compose down

sudo fuser -k "${APP_PORT}/tcp" || true

docker compose up -d
