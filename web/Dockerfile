FROM nginx:mainline

# Install certbot
RUN echo "deb http://ftp.debian.org/debian stretch-backports main" | tee /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y python-certbot-nginx -t stretch-backports

# Remove default configuration and add our custom Nginx configuration files
RUN rm /etc/nginx/conf.d/default.conf
COPY ./mattermost /etc/nginx/sites-available/
COPY ./mattermost-ssl /etc/nginx/sites-available/
COPY ./security.conf /etc/nginx/conf.d/

# Set certbot's volumes
VOLUME ["/etc/letsencrypt"]
VOLUME ["/var/lib/letsencrypt"]

# Add and setup entrypoint
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
