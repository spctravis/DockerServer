# Setting up Docker Server on Ubuntu

## Step 1: Update your system
First, make sure your system is up-to-date.

```bash
sudo apt-get update
```

## Step 2: Install Docker
Next, install Docker.

```bash
# sudo apt-get install docker.io
```

## Step 3: Start and Automate Docker
Start Docker and set it to launch at startup.

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

## Step 4: Check Docker Version
To ensure Docker has been installed correctly, check the version.

```bash
docker --version
```

## Step 5: Download Rocket.Chat Docker Image
Download the latest Rocket.Chat Docker image.

```bash
docker pull rocketchat/rocket.chat:latest
```

## Step 6: Set Up MongoDB
Rocket.Chat requires MongoDB. You can set up a MongoDB container using Docker.

```bash
docker run --name db -d mongo:4.0 --smallfiles --replSet rs0 --oplogSize 128
docker exec -ti db mongo --eval "printjson(rs.initiate())"
```

## Step 7: Install Nginx
First, install Nginx.

```bash
sudo apt-get install nginx
```

## Step 8: Configure Nginx
Create a new Nginx configuration file for Rocket.Chat.

```bash
sudo nano /etc/nginx/sites-available/rocketchat
```

Paste the following configuration into the file, replacing `chat.badger.lan` with your domain name.

```nginx
server {
    listen 80;

    server_name chat.badger.lan;

    location / {
        proxy_pass http://localhost:3000/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;

        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forward-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forward-Proto http;
        proxy_set_header X-Nginx-Proxy true;

        proxy_redirect off;
    }
}
```

Save and close the file.

## Step 9: Enable the Nginx Configuration
Enable the new configuration and restart Nginx.

```bash
sudo ln -s /etc/nginx/sites-available/rocketchat /etc/nginx/sites-enabled/
sudo systemctl restart nginx
```

## Step 10: Start Rocket.Chat Docker Container
Start the Rocket.Chat Docker container.

```bash
docker run --name rocketchat --link db -d rocketchat/rocket.chat
```

To access the Rocket.Chat server with the domain `chat.badger.lan`, you need to set up a reverse proxy. Here's how you can do it with Nginx:

```markdown
## Step 8: Install Nginx
First, install Nginx.

```bash
sudo apt-get install nginx
```

## Step 9: Configure Nginx
Create a new Nginx configuration file for Rocket.Chat.

```bash
sudo nano /etc/nginx/sites-available/rocketchat
```

Paste the following configuration into the file, replacing `chat.badger.lan` with your domain name.

```nginx
server {
    listen 80;

    server_name chat.badger.lan;

    location / {
        proxy_pass http://localhost:3000/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;

        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forward-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forward-Proto http;
        proxy_set_header X-Nginx-Proxy true;

        proxy_redirect off;
    }
}
```

Save and close the file.

## Step 10: Enable the Nginx Configuration
Enable the new configuration and restart Nginx.

```bash
sudo ln -s /etc/nginx/sites-available/rocketchat /etc/nginx/sites-enabled/
sudo systemctl restart nginx
```

Now, you can access Rocket.Chat at `http://chat.badger.lan`.


## Step 11: Download Isoflow Docker Image
Download the latest Isoflow Docker image.

```bash
docker pull markmanx/isoflow:latest
```

## Step 12: Configure Nginx for Isoflow
Create a new Nginx configuration file for Isoflow.

```bash
sudo nano /etc/nginx/sites-available/isoflow
```

Paste the following configuration into the file, replacing `netmap.badger.lan` with your domain name and `3001` with the port Isoflow is running on.

```nginx
server {
    listen 80;

    server_name netmap.badger.lan;

    location / {
        proxy_pass http://localhost:3001/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;

        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forward-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forward-Proto http;
        proxy_set_header X-Nginx-Proxy true;

        proxy_redirect off;
    }
}
```

Save and close the file.

## Step 13: Enable the Nginx Configuration for Isoflow
Enable the new configuration and restart Nginx.

```bash
sudo ln -s /etc/nginx/sites-available/isoflow /etc/nginx/sites-enabled/
sudo systemctl restart nginx
```

## Step 14: Start Isoflow Docker Container
Start the Isoflow Docker container on port 3001.

```bash
docker run --name isoflow --link db -p 3001:3001 -d markmanx/isoflow:latest
```
Now, you can access Isoflow at `http://netmap.badger.lan`.

## Step 15: Install Portainer
Portainer is a lightweight management UI which allows you to easily manage your Docker host or Swarm cluster.

First, pull the latest Portainer image:

```bash
docker pull portainer/portainer-ce:latest
```

## Step 16: Configure Nginx for Portainer
Create a new Nginx configuration file for Portainer.

```bash
sudo nano /etc/nginx/sites-available/portainer
```

Paste the following configuration into the file, replacing `manager.badger.lan` with your domain name and `3002` with the port Portainer is running on.

```nginx
server {
    listen 80;

    server_name manager.badger.lan;

    location / {
        proxy_pass http://localhost:3002/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;

        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forward-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forward-Proto http;
        proxy_set_header X-Nginx-Proxy true;

        proxy_redirect off;
    }
}
```

Save and close the file.

## Step 17: Enable the Nginx Configuration for Portainer
Enable the new configuration and restart Nginx.

```bash
sudo ln -s /etc/nginx/sites-available/portainer /etc/nginx/sites-enabled/
sudo systemctl restart nginx
```

Now, you can access Portainer at `http://manager.badger.lan`.

To add Etherpad to your Docker images and have it accessible on four different domains, you'll need to pull the Etherpad image, run four instances of it on different ports, and then configure Nginx to proxy requests to each domain to the corresponding Etherpad instance.

Here's how you can do it:

```markdown
## Step 18: Download Etherpad Docker Image
Download the latest Etherpad Docker image.

```bash
docker pull etherpad/etherpad:latest
```

## Step 19: Run Etherpad Docker Containers
Run four Etherpad Docker containers on different ports.

```bash
docker run --name etherpad1 -p 9001:9001 -d etherpad/etherpad
docker run --name etherpad2 -p 9002:9002 -d etherpad/etherpad
docker run --name etherpad3 -p 9003:9003 -d etherpad/etherpad
docker run --name etherpad4 -p 9004:9004 -d etherpad/etherpad
```

## Step 20: Configure Nginx for Etherpad
Create new Nginx configuration files for each Etherpad instance.

```bash
sudo nano /etc/nginx/sites-available/etherpad1
sudo nano /etc/nginx/sites-available/etherpad2
sudo nano /etc/nginx/sites-available/etherpad3
sudo nano /etc/nginx/sites-available/etherpad4
```

Paste the following configuration into each file, replacing `E1.badger.lan`, `E2.badger.lan`, `E3.badger.lan`, `support.badger.lan` with your domain names and `9001`, `9002`, `9003`, `9004` with the ports Etherpad is running on.

```nginx
server {
    listen 80;

    server_name E1.badger.lan; # Change this for each configuration file

    location / {
        proxy_pass http://localhost:9001/; # Change this for each configuration file
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;

        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forward-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forward-Proto http;
        proxy_set_header X-Nginx-Proxy true;

        proxy_redirect off;
    }
}
```

Save and close the files.

## Step 21: Enable the Nginx Configuration for Etherpad
Enable the new configurations and restart Nginx.

```bash
sudo ln -s /etc/nginx/sites-available/etherpad1 /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/etherpad2 /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/etherpad3 /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/etherpad4 /etc/nginx/sites-enabled/
sudo systemctl restart nginx
```

Now, you can access each Etherpad instance at `http://E1.badger.lan`, `http://E2.badger.lan`, `http://E3.badger.lan`, and `http://support.badger.lan`.


First, create a new directory for your markdown page and nginx configuration:

```bash
mkdir -p nginx/html
```

Then, create your markdown page in the `nginx/html` directory. Here's an example of what it might look like:

```markdown
# Services

- [e1](http://e1.badger.lan)
- [e2](http://e2.badger.lan)
- [e3](http://e3.badger.lan)
- [support](http://support.badger.lan)
```

Next, create an nginx configuration file in the `nginx` directory. Here's an example of what it might look like:

```nginx
server {
    listen 80;
    server_name badger.lan;

    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
}
```

This configuration will serve the files in the `/usr/share/nginx/html` directory at `http://badger.lan`.

Finally, add a new service to your `docker-compose.yml` file for the nginx server:

```yaml
  nginx:
    image: nginx:latest
    restart: always
    ports:
      - 80:80
    volumes:
      - ./nginx/html:/usr/share/nginx/html
      - ./nginx/nginx.conf:/etc/nginx/conf.d/default.conf
```

This service will start an nginx server that serves your markdown page at `http://badger.lan`. The `volumes` directive maps the `nginx/html` directory on your host to the `/usr/share/nginx/html` directory in the container, and the `nginx/nginx.conf` file on your host to the `/etc/nginx/conf.d/default.conf` file in the container.

Please note that you'll need to convert your markdown page to HTML for it to be served correctly by nginx. You can do this with a markdown converter like pandoc:

```bash
pandoc -s -o nginx/html/index.html nginx/html/index.md
```

This command will create an HTML file named `index.html` from your markdown file.