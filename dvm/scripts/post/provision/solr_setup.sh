#!/usr/bin/env bash

# Set up Drupal SOLR
SOLR=/opt/solr/example
SOLRCONF=/var/www/passport.vml.com/htdocs/sites/all/modules/contrib/search_api_solr/solr-conf
NEWCONF=solr/neoport.vml.com/conf
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