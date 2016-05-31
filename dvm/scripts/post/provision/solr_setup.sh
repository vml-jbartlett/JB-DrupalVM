#!/bin/bash

# Define a timestamp function
timestamp() {
  date +"%c"
}

# Set up Drupal SOLR
PROJECT_URL=projecturl.com
PROJECT_NAME=project_name

SOLR=/var/solr/$PROJECT_NAME
MODULE_CONF=/var/www/$PROJECT_URL/htdocs/sites/all/modules/contrib/search_api_solr/solr-conf
DVMCONF=/var/solr_files

if [ ! -e ~/.solr_setup ]; then
  if [ -e $DVMCONF/conf/schema.xml ]; then
    sudo ln -s /var/solr_files/ $SOLR
    sudo chown -R solr:solr $SOLR
    sudo service solr restart
    touch ~/.solr_setup
    echo "$(timestamp): SOLR Core $PROJECT_NAME has been set up." >> ~/.solr_setup
  else
    touch ~/.solr_setup
    echo "$(timestamp): No cores were detected in the dvm/solr/conf folder." >> ~/.solr_setup
  fi
else
  echo "$(timestamp): SOLR setup has already been run." >> ~/.solr_setup
fi
