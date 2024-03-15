#!/bin/bash

# Create directories
mkdir -p /opt/nginx/html

# Create markdown page
cat << EOF > nginx/html/index.md
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
pandoc -s -o nginx/html/index.html nginx/html/index.md

# Create nginx configuration
cat << EOF > nginx/nginx.conf
server {
    listen 80;
    server_name badger.lan;

    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
}
EOF

# Enable nginx configurations and restart nginx
sudo ln -s /etc/nginx/sites-available/badger.lan /etc/nginx/sites-enabled/
