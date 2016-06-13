#!/bin/bash

#Set these variables
PROJECT_NAME="project_name"
PROJECT_URL="$PROJECT_NAME.com"

# Define a timestamp function
timestamp() {
  date +"%c"
}

# Set up Drupal SOLR
WRITE_FILE="/home/vagrant/.solr_setup"
SOLR="/var/solr/collection1"
MODULE_CONF="/var/www/$PROJECT_URL/htdocs/sites/all/modules/contrib/search_api_solr/solr-conf"
SOLR_VERSION="3.x"
DVMCONF="/var/solr_files"

if [ ! -e $WRITE_FILE ]; then
  sudo cp -a $MODULE_CONF/$SOLR_VERSION/. $SOLR/conf/
  sudo chown -R solr:solr $SOLR/conf
  sudo service solr restart
  touch $WRITE_FILE
  echo "$(timestamp): Updated conf from file." >> $WRITE_FILE
else
  echo "$(timestamp): SOLR setup has already been run." >> $WRITE_FILE
fi
