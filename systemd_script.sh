#!/bin/bash

FOLDER_DIRECTORY="/home/s1mpleow/projects/postgreSQL-python"
FOLDER_CLIENT_DIRECTORY="${FOLDER_DIRECTORY}/client"
python="/bin/python3"

func_build_client() {
  if [-d $FOLDER_CLIENT_DIRECTORY ]; then
    cd $FOLDER_CLIENT_DIRECTORY
    echo "Installing client dependencies"
    if [-f "package-lock.json"]; then
      npm ci
    else
      npm install
    fi
  else
    echo "Client directory not found"
  fi

  echo "Building client"
  npm run build

}

func_install_server() {
  if ! [ -d $FOLDER_DIRECTORY ]; then
    mkdir -p $FOLDER_DIRECTORY
  fi
  cd $FOLDER_DIRECTORY

  $python -m venv venv

  if ! [ -f "requirements.txt" ]; then
    echo "requirements.txt not found"
    exit 1
  fi

  pip install -r requirements.txt

  if ! [ -f ".env" ]; then
    cp .env.sample .env
  fi
}

func_main() {
  func_install_server
  func_build_client
  source venv/bin/activate
  uvicorn main:app --env-file .env --host 127.0.0.1 --port 8000
}

func_main
