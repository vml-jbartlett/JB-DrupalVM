#!/bin/bash

#Set these variables
PROJECT_URL=projecturl.com
PROJECT_NAME=project_name

# Define a timestamp function
timestamp() {
  date +"%c"
}

# Set up Drupal SOLR
WRITE_FILE="/home/vagrant/.solr_setup"
SOLR="/var/solr/collection_1"
MODULE_CONF="/var/www/$PROJECT_URL/htdocs/sites/all/modules/contrib/search_api_solr/solr-conf"
SOLR_VERSION="4.x"
DVMCONF="/var/solr_files"

if [ ! -e $WRITE_FILE ]; then
#  if [ -e $DVMCONF/conf/schema.xml ]; then
#    sudo ln -s /var/solr_files/ $SOLR
#    sudo chown -R solr:solr $SOLR
#    sudo service solr restart
#    touch $WRITE_FILE
#    echo "$(timestamp): SOLR Core $PROJECT_NAME has been set up." >> $WRITE_FILE
#  else
    cp -R $MODULE_CONF/$SOLR_VERSION/. $SOLR/conf/
    sudo sed -i 's/\(<maxTime>\)\([^<]*\)\(<[^>]*\)/\11000\3/g' $SOLR/conf/solrconfig.xml
    sudo chown -R solr:solr $SOLR/conf
    sudo service solr restart
    touch $WRITE_FILE
    echo "$(timestamp): Updated conf from file." >> $WRITE_FILE
#  fi
else
  sudo service solr restart
  echo "$(timestamp): SOLR setup has already been run." >> $WRITE_FILE
fi
