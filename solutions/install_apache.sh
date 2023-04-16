#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
FOLDER="https://raw.githubusercontent.com/msaidcevik/my-projects/master/aws/projects/Project-101-kittens-carousel-static-website-ec2/static-web"
cd /var/www/html
sudo rm -rf index.html
wget $FOLDER/index.html
wget $FOLDER/cat0.jpg
wget $FOLDER/cat1.jpg
wget $FOLDER/cat2.jpg
wget $FOLDER/cat3.png
sudo systemctl start apache2
sudo systemctl enable apache2

