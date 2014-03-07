# Init script for halloboekarest.com site
# TODO: use rsync to get data from production server

echo "Commencing halloboekarest.com Setup"

# Make a database, if we don't already have one
echo "Creating database for halloboekarest if it's not already there"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS halloboekarest"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON halloboekarest.* TO wp@localhost IDENTIFIED BY 'wp';"

mysql -u root --password=root -h localhost halloboekarest < halloboekarest.sql

# Remove wp-config.php
rm wp-config.php

# Use WP CLI to create a `wp-config.php` file
wp core config --dbname="halloboekarest" --dbuser=wp --dbpass=wp --dbhost="localhost" --allow-root

# The Vagrant site setup script will restart Nginx for us

# regenerate thumbnails
echo "regenerating thumbnails"
wp media regenerate

# Let the user know the good news
echo "WordPress hallboekarest site now installed";