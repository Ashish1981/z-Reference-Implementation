# FROM ashish1981/x86-rbase-shiny-plumber
FROM docker.io/ashish1981/s390x-clefos-shiny
#
#copy application
COPY /app /srv/shiny-server/
#
# Copy configuration files into the Docker image
RUN su - -c "R -e \"install.packages(c('DT'), repos='https://cloud.r-project.org')\""
RUN mkdir -p /var/log/supervisord

COPY shiny-server.conf  /etc/shiny-server/shiny-server.conf
COPY shiny-server.sh /usr/bin/shiny-server.sh
RUN chmod +x /usr/bin/shiny-server.sh
COPY run-myfile1.R /srv/shiny-server/run-myfile1.R
COPY run-myfile2.R /srv/shiny-server/run-myfile2.R
COPY plumb_1.sh /usr/bin/plumb_1.sh
COPY plumb_2.sh /usr/bin/plumb_2.sh
RUN chmod +x /usr/bin/plumb_1.sh \
    && chmod +x  /usr/bin/plumb_2.sh \
    && mkdir -p /var/log/supervisord/plumber1 \
    && mkdir -p /var/log/supervisord/plumber2
RUN rm -rf /tmp/*
#
# Make the ShinyApp available at port 1240
EXPOSE 1240 8000 8100
#
# Copy further configuration files into the Docker image
COPY /supervisord.conf /etc/
RUN chgrp -Rf root  /var/log/supervisord && chmod -Rf g+rwx /var/log/supervisord
RUN chgrp -Rf shiny /var/log/supervisord/plumber1 && chmod -Rf g+rwx /var/log/supervisord/plumber1
RUN chgrp -Rf shiny /var/log/supervisord/plumber2 && chmod -Rf g+rwx /var/log/supervisord/plumber2
RUN chgrp -Rf shiny /var/log/shiny-server && chmod -Rf g+rwx /var/log/shiny-server
RUN chgrp -Rf shiny /srv/shiny-server && chmod -Rf g+rwx /srv/shiny-server
RUN chgrp -Rf shiny /var/lib/shiny-server && chmod -Rf g+rwx /var/lib/shiny-server
RUN chgrp -Rf shiny /etc/shiny-server && chmod -Rf g+rwx /etc/shiny-server

RUN chmod -Rf g+rwx /var/log/supervisord
RUN chmod -Rf g+rwx /var/log/shiny-server 
RUN chmod -Rf g+rwx /srv/shiny-server
RUN chmod -Rf g+rwx /var/lib/shiny-server
RUN chmod -Rf g+rwx /etc/shiny-server

# RUN chown -Rf shiny.shiny /var/log/supervisord/
RUN chown -Rf shiny.shiny /var/log/shiny-server 
RUN chown -Rf shiny.shiny /srv/shiny-server
RUN chown -Rf shiny.shiny /var/lib/shiny-server
RUN chown -Rf shiny.shiny /etc/shiny-server

#VOLUME [ "/tmp/log/supervisord" ]
WORKDIR /var/log/supervisord
#

# ###Adjust permissions on /etc/passwd so writable by group root.
RUN chmod g+w /etc/passwd
### Access Fix 24
# COPY /scripts/uid-set.sh /usr/bin/uid-set.sh
# RUN chmod +x /usr/bin/uid-set.sh
# RUN /usr/bin/uid-set.sh
####################
#
#
# USER shiny
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]