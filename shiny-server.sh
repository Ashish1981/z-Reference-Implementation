#!/bin/sh
# Ensure that assigned uid has entry in /etc/passwd.
if [ `id -u` -ge 10000 ]; then
 cat /etc/passwd | sed -e "s/^shiny:/builder:/" > /tmp/passwd
 echo "shiny:x:`id -u`:`id -g`:,,,:/srv/shiny-server:/bin/bash" >> /tmp/passwd
 cat /tmp/passwd > /etc/passwd
 rm /tmp/passwd
 fi
# Make sure the directory for individual app logs exists
mkdir -p /var/log/shiny-server
chown shiny.shiny /var/log/shiny-server

if [ "$APPLICATION_LOGS_TO_STDOUT" != "false" ];
then
    # push the "real" application logs to stdout with xtail in detached mode
    exec xtail /var/log/shiny-server &
fi

# start shiny server
exec shiny-server 2>&1