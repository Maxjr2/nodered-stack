FROM nginx:stable-alpine
RUN mkdir -p /etc/ssl/certs
RUN mkdir -p /etc/ssl/privates
COPY generate-certs.sh /usr/local/bin/generate-certs.sh
VOLUME ./proxy_config:/etc/nginx/conf.d
VOLUME ./host_privates:/etc/ssl/private:ro
VOLUME ./host_certs:/etc/ssl/certs:ro
EXPOSE 80 443
ENTRYPOINT ["/usr/local/bin/generate-certs.sh"]
CMD ["/usr/local/bin/generate-certs.sh"]
CMD ["nginx -s reload"]

FROM portainer/portainer-ce:latest
VOLUME /etc/localtime:/etc/localtime:ro
VOLUME /var/run/docker.sock:/var/run/docker.sock:ro
VOLUME ./portainer-data:/data

FROM nodered/node-red:latest
ENV TZ=Europe/Berlin
VOLUME ./nodered-data:/data

FROM statping/statping
VOLUME ./statping-data:/app
ENV DB_CONN=sqlite
