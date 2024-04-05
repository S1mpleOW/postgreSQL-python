#!/bin/sh
APP_NAME="postgresql-python"
APP_PORT="8080"
PROCESS_NAME="${APP_NAME}.service"

sudo cp "${APP_NAME}.service" /lib/systemd/system/

sudo chmod +x "/lib/systemd/system/${APP_NAME}.service"

sudo systemctl daemon-reload

sudo fuser -k "${APP_PORT}/tcp" || true

sudo systemctl start "${PROCESS_NAME}"

sleep 10

sudo systemctl status "${PROCESS_NAME}"
