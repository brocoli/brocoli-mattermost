#!/bin/sh
set -e

args="$*"

if [ "$args" = 'nginx -g daemon off;' ]; then
    # Linking non-ssl nginx configuration file
    ln -s /etc/nginx/sites-available/mattermost /etc/nginx/conf.d/mattermost.conf

    # Setup app host and port on configuration file
    sed -i "s/{%APP_HOST%}/app/g" /etc/nginx/conf.d/mattermost.conf
    sed -i "s/{%APP_PORT%}/80/g" /etc/nginx/conf.d/mattermost.conf

    (
        sleep 10

        # Run certbot certonly.
        # If your volume mounts are set up correctly this should only spend an ACME challenge
        # when no valid certificates are found in "/etc/letsencrypt/live/${APP_DOMAIN}"
        certbot -n -m REPLACE_WITH_EMAIL --agree-tos -d "${APP_DOMAIN}" --nginx certonly

        # Linking ssl nginx configuration file
        rm /etc/nginx/conf.d/mattermost.conf
        ln -s /etc/nginx/sites-available/mattermost-ssl /etc/nginx/conf.d/mattermost.conf

        # Setup app host, port and domain on configuration file
        sed -i "s/{%APP_HOST%}/app/g" /etc/nginx/conf.d/mattermost.conf
        sed -i "s/{%APP_PORT%}/80/g" /etc/nginx/conf.d/mattermost.conf
        sed -i "s/{%APP_DOMAIN%}/${APP_DOMAIN}/g" /etc/nginx/conf.d/mattermost.conf

        # Reload nginx
        echo "Reloading nginx" >> /proc/1/fd/1
        /etc/init.d/nginx configtest && /etc/init.d/nginx reload
    )&

    # Run Nginx
    echo "Starting nginx with '$args' for pre-certbot setup" >> /proc/1/fd/1
    exec "$@"
else
    echo "Running custom command '$args'" >> /proc/1/fd/1
    exec "$@"
fi
