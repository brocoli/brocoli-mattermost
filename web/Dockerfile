FROM nginx:mainline-alpine

# Remove default configuration and add our custom Nginx configuration files
RUN rm /etc/nginx/conf.d/default.conf
COPY ./mattermost /etc/nginx/sites-available/
COPY ./mattermost-ssl /etc/nginx/sites-available/
COPY ./security.conf /etc/nginx/conf.d/

# Install certbot
RUN wget https://dl.eff.org/certbot-auto \
    && chmod a+x certbot-auto

# Set /etc/letsencrypt as a volume, so that we don't re-create the cert
# needlessly, as long as the instance is the same.
VOLUME ['/etc/letsencrypt']

# Add and setup entrypoint
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
