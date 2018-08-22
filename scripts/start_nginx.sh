#!/bin/bash

# Fist use the default conf file to start the service;
# reload_nginx.sh will pick up the new conf once it is formatted correctly by the jar
nginx

# Edit the template
sed -i "s/<replace_with_server_name>/${SERVER_NAME}/g" /opt/semosshome/nginx/templates/upstream.conf

# Run the watcher
java -classpath /opt/semosscluster.jar prerna.cluster.util.NGINXStarter