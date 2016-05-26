#!/usr/bin/env bash

# Set up Drupal SOLR
PROJECT_URL=production_url
SOLR=/opt/solr/example
SOLRCONF=/var/www/$PROJECT_URL/htdocs/sites/all/modules/contrib/search_api_solr/solr-conf
NEWCONF=solr/$PROJECT_URL/conf
EXTCONF=/var/solr_files

cd $SOLR

if [ ! -e "$NEWCONF" ]; then

    if [ -e "$EXTCONF" ]; then
        cp -a $EXTCONF/. $NEWCONF/
        chown -R solr:solr $NEWCONF
        java -jar start.jar &
        cd
else if [ -e "conf" ]; then
    cp -a $SOLRCONF/4.x/. $NEWCONF/
    chown -R solr:solr $NEWCONF
    java -jar start.jar &
    cd
else
    cd
done