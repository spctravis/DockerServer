#!/bin/bash

# Pull the latest Portainer image
docker pull portainer/portainer-ce:latest

# Create Nginx configuration file for Portainer
echo "server {
    listen 80;
    server_name manager.badger.lan;
    location / {
        proxy_pass http://localhost:3002;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \"upgrade\";
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forward-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forward-Proto http;
        proxy_set_header X-Nginx-Proxy true;
        proxy_redirect off;
    }
}" | sudo tee /etc/nginx/sites-available/portainer

# Enable the site by creating a symbolic link to the sites-enabled directory
sudo ln -s /etc/nginx/sites-available/portainer /etc/nginx/sites-enabled/

# Test Nginx configuration
sudo nginx -t

# If the configuration test is successful, reload Nginx to apply the changes
sudo systemctl reload nginx