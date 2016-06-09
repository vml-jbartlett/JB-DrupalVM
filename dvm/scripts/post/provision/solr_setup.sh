#!/bin/bash

#Set these variables
PROJECT_URL=projecturl.com
PROJECT_NAME=project_name

# Define a timestamp function
timestamp() {
  date +"%c"
}

# Set up Drupal SOLR
WRITE_FILE=/home/vagrant/.solr_setup
SOLR=/var/solr/$PROJECT_NAME
MODULE_CONF=/var/www/$PROJECT_URL/htdocs/sites/all/modules/contrib/search_api_solr/solr-conf
DVMCONF=/var/solr_files

if [ ! -e $WRITE_FILE ]; then
  if [ -e $DVMCONF/conf/schema.xml ]; then
    sudo ln -s /var/solr_files/ $SOLR
    sudo chown -R solr:solr $SOLR
    sudo service solr restart
    touch $WRITE_FILE
    echo "$(timestamp): SOLR Core $PROJECT_NAME has been set up." >> $WRITE_FILE
  else
    touch $WRITE_FILE
    echo "$(timestamp): No cores were detected in the dvm/solr/conf folder." >> $WRITE_FILE
  fi
else
  sudo service solr restart
  echo "$(timestamp): SOLR setup has already been run." >> $WRITE_FILE
fi
