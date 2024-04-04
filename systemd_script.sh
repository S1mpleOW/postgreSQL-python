#!/bin/bash

FOLDER_DIRECTORY="/home/s1mpleow/projects/postgreSQL-python"
python="/bin/python3"

if ! [ -d $FOLDER_DIRECTORY ]; then
  mkdir -p $FOLDER_DIRECTORY
fi
cd $FOLDER_DIRECTORY

$python -m venv venv

source venv/bin/activate

uvicorn main:app --env-file .env --host 127.0.0.1 --port 8000
