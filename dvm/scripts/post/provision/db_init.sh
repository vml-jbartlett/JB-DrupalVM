#!/bin/bash bash

# Install database from backup directory

# DBBK=~/Sites/passport.vml.com/dvm/db_backups/
DBBK=/var/db_backups/
cd $DBBK

PROJECT_NAME=passport
FILE=($PROJECT_NAME*.mysql.gz)

if [ -e "$FILE" ]; then
    drush @$PROJECT_NAME.local sql-drop
    drush @$PROJECT_NAME.local sql-cli < $DBBK/$FILE
    drush @$PROJECT_NAME.local fra -y
    drush @$PROJECT_NAME.local updb
    echo "SQL restored from backup.\n"
    cd
else
  cd
  echo "No SQL backups were detected.\n"
fi
