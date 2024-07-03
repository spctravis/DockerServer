#!/bin/bash

# Create directories
mkdir -p /opt/nginx/html

# Create markdown page
cat << EOF > /opt/nginx/html/index.md
# Services

- [chat](http://chat.badger.lan)
- [netmap](http://netmap.badger.lan)
- [e1](http://e1.badger.lan)
- [e2](http://e2.badger.lan)
- [e3](http://e3.badger.lan)
- [support](http://support.badger.lan)
- [manager](http://manager.badger.lan)
EOF

# Convert markdown to HTML
pandoc -s -o /opt/nginx/html/index.html /opt/nginx/html/index.md

# Create nginx configuration
cat << EOF > /opt/nginx/nginx.conf
server {
    listen 80;
    server_name badger.lan;

    location / {
        root /opt/nginx/html;
        index index.html;
    }
}
EOF

# Enable nginx configurations and restart nginx
sudo ln -s /etc/nginx/sites-available/badger.lan /etc/nginx/sites-enabled/
