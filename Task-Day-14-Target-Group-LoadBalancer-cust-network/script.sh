#!/bin/bash
sudo su -
yum install -y nginx
systemctl enable nginx
systemctl start nginx
echo "<h1>Hello from Nginx on Private EC2</h1>" > /var/www/html/index.html