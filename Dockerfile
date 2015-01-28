FROM binhex/arch-base:2015010500
MAINTAINER binhex

# additional files
##################

# add supervisor conf file for app
ADD deluge.conf /etc/supervisor/conf.d/deluge.conf

# install app
#############

# install install app using pacman, set perms, cleanup
RUN pacman -Sy --noconfirm && \
	pacman -S ufw unzip unrar librsvg pygtk python2-service-identity python2-mako python2-notify deluge --noconfirm && \
	chown -R nobody:users /usr/bin/deluged /usr/bin/deluge-web /root && \
	chmod -R 775 /usr/bin/deluged /usr/bin/deluge-web /root && \	
	yes|pacman -Scc && \	
	rm -rf /usr/share/locale/* && \
	rm -rf /usr/share/man/* && \
	rm -rf /root/* && \
	rm -rf /tmp/*

# docker settings
#################

# map /config to host defined config path (used to store configuration from app)
VOLUME /config

# map /data to host defined data path (used to store data from app)
VOLUME /data

# expose port for http
EXPOSE 8112

# expose port for deluge daemon
EXPOSE 58846

# expose port for incoming torrent data (tcp and udp)
EXPOSE 58946
EXPOSE 58946/udp

# run supervisor
################

# run supervisor
CMD ["supervisord", "-c", "/etc/supervisor.conf", "-n"]