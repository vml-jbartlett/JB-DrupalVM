#!/bin/bash

#Set this variable
PROJECT_NAME="employee"
PROJECT_URL="$PROJECT_NAME.vml.com"

# Define a timestamp function
timestamp() {
  date +"%c"
}

# Initial database from backup directory
DBBK="/var/backups/files"
TARGET="/var/www/$PROJECT_URL/htdocs/sites/default/files"
WRITE_FILE="/home/vagrant/.file_init"

if [ ! -e $WRITE_FILE ]; then
  if [ -e $DBBK/$FILE ]; then
    cp -R $DBBK/. $TARGET
    chmod 2755 -R $TARGET
    touch $WRITE_FILE
    echo "$(timestamp): Files directory built from initial $PROJECT_NAME files backup." >> $WRITE_FILE
  else
    touch $WRITE_FILE
    echo "$(timestamp): No file backups found in backups folder." >> $WRITE_FILE
  fi
else
  echo "$(timestamp): File Init has already been run." >> $WRITE_FILE
fi
