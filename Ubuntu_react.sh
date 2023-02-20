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
sudo certbot --nginx -d $website_name

# Set up a new server block for the website
sudo mkdir -p /var/www/$website_name/html
sudo chown -R $USER:$USER /var/www/$website_name/html
sudo chmod -R 755 /var/www/$website_name
sudo nano /etc/nginx/sites-available/$website_name

# In the editor, add the following block:
#
# server {
#     listen 80;
#     listen [::]:80;
#     server_name $website_name www.$website_name;
#     root /var/www/$website_name/html;
#     index index.html;
#     location / {
#         try_files $uri $uri/ =404;
#     }
# }

# Enable the new server block
sudo ln -s /etc/nginx/sites-available/$website_name /etc/nginx/sites-enabled/

# Test the Nginx configuration
sudo nginx -t

# Restart Nginx to apply the changes
sudo systemctl restart nginx
