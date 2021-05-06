#!/bin/sh
export LD_LIBRARY_PATH=/usr/lib/jvm/java-11-openjdk-s390x/lib/server:/usr/lib/jvm/java-11-openjdk-s390x
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-s390x
/usr/local/bin/r /srv/shiny-server/run-myfile2.R