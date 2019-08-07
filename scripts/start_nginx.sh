#!/bin/bash

# Fist use the default conf file to start the service;
# reload_nginx.sh will pick up the new conf once it is formatted correctly by the jar
rm /opt/semosshome/nginx/conf/nginx.conf
cp /etc/nginx/nginx.conf /opt/semosshome/nginx/conf/nginx.conf
nginx -c /opt/semosshome/nginx/conf/nginx.conf

# Edit the template
sed -i "s/<replace_with_server_name>/${SERVER_NAME}/g" /opt/semosshome/nginx/templates/upstream.conf

if [[ -z "${NGINX_ROUTE}" ]]; then
sed -i "s@sticky;@sticky name=$NGINX_ROUTE;@g" /opt/semosshome/nginx/templates/upstream.conf
fi

# Run the watcher
java -classpath /opt/semosscluster.jar prerna.cluster.util.NGINXStarter
