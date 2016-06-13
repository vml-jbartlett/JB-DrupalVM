#!/bin/bash

#Set this variable
PROJECT_NAME=project_name

# Define a timestamp function
timestamp() {
  date +"%c"
}

# Initial database from backup directory
DBBK="/var/db_backups"
FILE="$PROJECT_NAME-*.mysql.gz"
WRITE_FILE="/home/vagrant/.db_init"

if [ ! -e $WRITE_FILE ]; then
  cd $DBBK
  if [ -e $DBBK/$FILE ]; then
    drush @$PROJECT_NAME.local sql-drop -y
    drush @$PROJECT_NAME.local sql-cli < $DBBK/$FILE
    drush @$PROJECT_NAME.local fra -y
    drush @$PROJECT_NAME.local updb -y
    touch $WRITE_FILE
    echo "$(timestamp): SQL restored from recent $PROJECT_NAME backup." >> $WRITE_FILE
    cd
  elif [ -e $DBBK/initial_db.mysql.gz ]; then
    drush @$PROJECT_NAME.local sql-drop -y
    drush @$PROJECT_NAME.local sql-cli < $DBBK/initial_db.mysql.gz
    drush @$PROJECT_NAME.local fra -y
    drush @$PROJECT_NAME.local updb -y
    touch $WRITE_FILE
    echo "$(timestamp): SQL restored from default backup." >> $WRITE_FILE
    cd
  else
    touch $WRITE_FILE
    echo "$(timestamp): No backups found in db_backups folder." >> $WRITE_FILE
  fi
else
  echo "$(timestamp): DB Init has already been run." >> $WRITE_FILE
fi
