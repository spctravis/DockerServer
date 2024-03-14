#!/bin/bash

# Create a directory for Isoflow
mkdir -p /opt/isoflow

# Change to the new directory
cd /opt/isoflow

# Build the Docker image for Isoflow
docker pull markmanx/isoflow:latest

# Create Nginx configuration file for Isoflow
echo "server {
    listen 80;
    server_name netmap.badger.lan;
    location / {
        proxy_pass http://localhost:3000;
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
}" | sudo tee /etc/nginx/sites-available/isoflow

# Enable the site by creating a symbolic link to the sites-enabled directory
sudo ln -s /etc/nginx/sites-available/isoflow /etc/nginx/sites-enabled/

# Test Nginx configuration
sudo nginx -t

# If the configuration test is successful, reload Nginx to apply the changes
sudo systemctl reload nginx