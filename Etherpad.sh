#!/bin/bash

# Pull the Etherpad Docker image
docker pull etherpad/etherpad

# Create directories for Etherpad
mkdir -p /opt/etherpad-lite/var

# Create Nginx configuration files for each Etherpad instance
for i in {1..4}
do
    echo "server {
    listen 80;
    server_name E${i}.badger.lan;
    location / {
        proxy_pass http://localhost:900${i};
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
}" | sudo tee /etc/nginx/sites-available/etherpad${i}
    sudo ln -s /etc/nginx/sites-available/etherpad${i} /etc/nginx/sites-enabled/
done

# Restart Nginx to apply the changes
sudo systemctl restart nginx