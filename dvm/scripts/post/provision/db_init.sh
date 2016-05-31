#!/bin/bash

# Define a timestamp function
timestamp() {
  date +"%c"
}

# Initial database from backup directory

DBBK=/var/db_backups
PROJECT_NAME=project_name
FILE=(*.mysql.gz)

if [ ! -e ~/.db_init ]; then
  cd $DBBK
  if [ -e $DBBK/$FILE ]; then
    drush @$PROJECT_NAME.local sql-drop -y
    drush @$PROJECT_NAME.local sql-cli < $DBBK/$FILE
    drush @$PROJECT_NAME.local fra -y
    drush @$PROJECT_NAME.local updb -y
    touch ~/.db_init
    echo "$(timestamp): SQL restored from backup." >> ~/.db_init
    cd
  else
    touch ~/.db_init
    echo "$(timestamp): No SQL backups were detected." >> ~/.db_init
    cd
  fi
else
  echo "$(timestamp): DB Init has already been run." >> ~/.db_init
fi
