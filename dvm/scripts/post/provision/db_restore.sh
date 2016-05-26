#!/usr/bin/env bash

# Install database from backup directory
DBBK=/var/db_backups/
cd $DBBK

FILE=(Passport*.mysql.gz)

if [ ! -e "$FILE" ]; then
    while true; do
    read -p "I see you have a backup in the db_backups folder. Would you like to restore your database from it?" yn
    case $yn in
        [Yy]* ) drush @passport.local sqldrop; drush @passport.local sql-cli < $DBBK/$FILE; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
    drush @passport.local sql-cli < $DBBK/$FILE
    drush @passport.local fra -y
    drush @passport.local updb
    cd
else
    cd
fi