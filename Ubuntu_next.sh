#!/bin/bash

# Update package repository and install Nginx
sudo apt-get update
sudo apt-get install nginx

# Start Nginx
sudo systemctl start nginx

# Configure Nginx to start automatically on boot
sudo systemctl enable nginx

# Open up the firewall to allow HTTP and HTTPS traffic
sudo ufw allow 'Nginx Full'

# Install Certbot
sudo add-apt-repository ppa:certbot/certbot -y
sudo apt-get update
sudo apt-get install certbot python3-certbot-nginx -y

# Prompt user for website name
read -p "Enter website name: " website_name

# Set up Certbot for Nginx
sudo certbot --nginx -d $website_name -d www.$website_name

# Set up a new server block for the website
sudo mkdir -p /var/www/$website_name/html
sudo chown -R $USER:$USER /var/www/$website_name/html
sudo chmod -R 755 /var/www/$website_name
sudo nano /etc/nginx/sites-available/$website_name

# In the editor, add the following block:
#
# server {
#     server_name $website_name www.$website_name;
# 
#     if ($host = www.$website_name) {
#         return 301 https://$website_name$request_uri;
#     }
# 
#     location / {
#         proxy_pass http://localhost:3000;
#         proxy_http_version 1.1;
#         proxy_set_header Upgrade $http_upgrade;
#         proxy_set_header Connection 'upgrade';
#         proxy_set_header Host $host;
#         proxy_cache_bypass $http_upgrade;
#     }
# 
#     listen [::]:443 ssl; # managed by Certbot
#     listen 443 ssl; # managed by Certbot
#     ssl_certificate /etc/letsencrypt/live/$website_name/fullchain.pem; # managed by Certbot
#     ssl_certificate_key /etc/letsencrypt/live/$website_name/privkey.pem; # managed by Certbot
#     include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
#     ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
# }
#
# server {
#     if ($host = www.$website_name) {
#         return 301 https://$website_name$request_uri;
#     } # managed by Certbot
# 
#     if ($host = $website_name) {
#         return 301 https://$host$request_uri;
#     } # managed by Certbot
# 
#     listen 80;
#     listen [::]:80;
# 
#     server_name $website_name www.$website_name;
#     return 404; # managed by Certbot
# }

# Enable the new server block
sudo ln -s /etc/nginx/sites-available/$website_name /etc/nginx/sites-enabled/

# Test the Nginx configuration
sudo nginx -t

# Restart Nginx to apply the changes
sudo systemctl restart nginx
