#!/bin/bash

# Init script for halloboekarest.com site


# Function to pretty-print stuff on the screen
function announce {
   echo " "
   echo " "
   echo ------------------------------------------------------------
   echo $*
   date
   echo ------------------------------------------------------------
   echo " "
}

announce "Commencing halloboekarest.com Setup"

cd `dirname $0`

announce "Starting up"
echo Working path:
pwd

announce "Writing remote database backup"
ssh halloboekarest PATH_TO_DATABASE_BACUP_SCRIPT
announce "Syncing files"
rsync --progress --archive --rsh=ssh halloboekarest:"PATH_TO_YOUR_PRODUCTION_WORDPRESS_FOLDER" ./
announce "Syncing database"
rsync --progress --archive --rsh=ssh halloboekarest:"PATH_TO_PRODUCTION_DATABASE_BACUP" ../../database/backups/

#announce "Performing versioned backup"
#rdiff-backup mirror history

announce "Done sync from production"

# Make a database, if we don't already have one
announce "Creating database for halloboekarest if it's not already there"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS halloboekarest"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON halloboekarest.* TO wp@localhost IDENTIFIED BY 'wp';"


announce "Importing database dump to MYSQL"
mysql -u root --password=root -h localhost halloboekarest < ../../database/backups/halloboekarest.sql

# Remove wp-config.php
rm wp-config.php

# Use WP CLI to create a `wp-config.php` file
wp core config --dbname="halloboekarest" --dbuser=wp --dbpass=wp --dbhost="localhost" --allow-root

# The Vagrant site setup script will restart Nginx for us

# regenerate thumbnails
#echo "regenerating thumbnails"
#wp media regenerate

# Let the user know the good news
announce "WordPress hallboekarest site now installed";