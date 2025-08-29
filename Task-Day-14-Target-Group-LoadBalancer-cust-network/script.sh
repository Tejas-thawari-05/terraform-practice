#!/bin/bash
sudo su -
yum install -y httpd
systemctl enable httpd
systemctl start httpd
echo "<h1>Hello from http on Private EC2</h1>" > /var/www/html/index.html
