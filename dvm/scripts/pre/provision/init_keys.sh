#!/bin/bash

#Set this variable
PROJECT_NAME=project_name
PROJECT_LOCAL=local.projecturl.com

COUNTRY=country
STATE=state
LOCALE=city
ORG_NAME=org
COMMON_NAME=$PROJECT_LOCAL

# Define a timestamp function
timestamp() {
  date +"%c"
}

# Initial database from backup directory
KEYS=/var/keys
FILE=($PROJECT_NAME.crt)
WRITE_FILE=/home/vagrant/.init_keys

if [ ! -e $WRITE_FILE ]; then
  cd $KEYS
  if [ ! -e $KEYS/$FILE ]; then
    openssl req -newkey rsa:2048 -nodes -keyout $PROJECT_NAME.key -x509 -days 365 -out $PROJECT_NAME.crt -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALE/O=$ORG_NAME/CN=$COMMON_NAME"
    touch $WRITE_FILE
    echo "$(timestamp): Keys created for $PROJECT_NAME." >> $WRITE_FILE
    cd
  else
    touch $WRITE_FILE
    echo "$(timestamp): Keys already exist for $PROJECT_NAME." >> $WRITE_FILE
    cd
  fi
else
  echo "$(timestamp): Build Cert has already been run." >> $WRITE_FILE
fi
