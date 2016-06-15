#!/bin/bash

#Set this variable
PROJECT_NAME="Project_Name"
LOWER_NAME="${PROJECT_NAME,,}"

# Define a timestamp function
timestamp() {
  date +"%c"
}

# Initial database from backup directory
DBBK="/var/backups"
FILE="$PROJECT_NAME-*.mysql.gz"
WRITE_FILE="/home/vagrant/.db_init"

if [ ! -e $WRITE_FILE ]; then
  if [ -e $DBBK/$FILE ]; then
    drush @$LOWER_NAME.local sql-drop -y
    drush @$LOWER_NAME.local sql-cli < $DBBK/$FILE
    drush @$LOWER_NAME.local updb -y
    touch $WRITE_FILE
    echo "$(timestamp): SQL restored from recent $PROJECT_NAME backup." >> $WRITE_FILE
  elif [ -e $DBBK/initial_db.mysql.gz ]; then
    drush @$LOWER_NAME.local sql-drop -y
    drush @$LOWER_NAME.local sql-cli < $DBBK/initial_db.mysql.gz
    drush @$LOWER_NAME.local updb -y
    touch $WRITE_FILE
    echo "$(timestamp): SQL restored from default backup." >> $WRITE_FILE
  else
    touch $WRITE_FILE
    echo "$(timestamp): No backups found in db_backups folder." >> $WRITE_FILE
  fi
else
  echo "$(timestamp): DB Init has already been run." >> $WRITE_FILE
fi
