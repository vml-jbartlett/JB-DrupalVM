#!/bin/bash

# Define a timestamp function
timestamp() {
  date +"%c"
}

# Initial database from backup directory

DBBK=/var/db_backups
PROJECT_NAME=project_name
FILE=(*.mysql.gz)
WRITE_FILE=/home/vagrant/.db_init

if [ ! -e $WRITE_FILE ]; then
  cd $DBBK
  if [ -e $DBBK/$FILE ]; then
    drush @$PROJECT_NAME.local sql-drop -y
    drush @$PROJECT_NAME.local sql-cli < $DBBK/$FILE
    drush @$PROJECT_NAME.local fra -y
    drush @$PROJECT_NAME.local updb -y
    touch $WRITE_FILE
    echo "$(timestamp): SQL restored from backup." >> $WRITE_FILE
    cd
  else
    touch $WRITE_FILE
    echo "$(timestamp): No SQL backups were detected." >> $WRITE_FILE
    cd
  fi
else
  echo "$(timestamp): DB Init has already been run." >> $WRITE_FILE
fi
