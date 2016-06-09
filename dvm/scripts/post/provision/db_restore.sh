#!/bin/bash bash

#Set this variable
PROJECT_NAME=project_name

# Install database from backup directory
DBBK=/var/db_backups
FILE=(*.mysql.gz)

while [ -e $DBBK/$FILE ]; do
    read -p "I see you have a backup in the db_backups folder. Would you like to restore your database from it? (y/n)" yn
    case $yn in
        [Yy]* ) drush @$PROJECT_NAME.local sql-drop; drush @$PROJECT_NAME.local sql-cli < $DBBK/$FILE; drush @$PROJECT_NAME.local fra -y; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

drush @$PROJECT_NAME.local updb;