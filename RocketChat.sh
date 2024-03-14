#!/bin/bash

# Create a directory for Rocket.Chat
mkdir -p /opt/rocketchat

# Change to the new directory
cd /opt/rocketchat

# Create a docker-compose.yml file
cat << EOF > docker-compose.yml
version: '2'
services:
  rocketchat:
    image: rocketchat/rocket.chat:latest
    restart: unless-stopped
    volumes:
      - ./uploads:/app/uploads
    environment:
      - PORT=3000
      - ROOT_URL=http://chat.badger.lan
      - MONGO_URL=mongodb://mongo:27017/rocketchat
      - MONGO_OPLOG_URL=mongodb://mongo:27017/local
    depends_on:
      - mongo
    ports:
      - 3000:3000

  mongo:
    image: mongo:4.0
    restart: unless-stopped
    volumes:
     - ./data/db:/data/db
     - ./data/dump:/dump
    command: mongod --smallfiles --oplogSize 128 --replSet rs0 --storageEngine=mmapv1

  # this container's job is just run the command to initialize the replica set.
  # it will run the command and remove himself (it will not stay running)
  mongo-init-replica:
    image: mongo:4.0
    command: >
      bash -c "
        sleep 10 ;
        mongo mongo/rocketchat --eval \"
          rs.initiate({
            _id: 'rs0',
            members: [ { _id: 0, host: 'localhost:27017' } ]})\"
      "
    depends_on:
      - mongo
EOF

# Start Rocket.Chat
docker-compose up -d

# Create Nginx configuration file for Rocket.Chat
echo "server {
    listen 80;
    server_name chat.badger.lan;
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
}" | sudo tee /etc/nginx/sites-available/rocketchat

# Enable the site by creating a symbolic link to the sites-enabled directory
sudo ln -s /etc/nginx/sites-available/rocketchat /etc/nginx/sites-enabled/

# Test Nginx configuration
sudo nginx -t

# If the configuration test is successful, reload Nginx to apply the changes
sudo systemctl reload nginx