#! /bin/bash
sudo apt-get update
home=/home/ubuntu
folder=$home/localfolder
/usr/bin/git clone https://MWyssy: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@github.com/MWyssy/ce-terraform-project-html-host.git $folder
sudo apt-get install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
sudo rm /etc/nginx/sites-enabled/default
sudo rm /usr/share/nginx/html/index.html
sudo rm /etc/nginx/nginx.conf
cd /home/ubuntu/localfolder
sudo mv index.html /usr/share/nginx/html/index.html
sudo mv styles.css /usr/share/nginx/html/styles.css
sudo mv nginx.conf /etc/nginx/nginx.conf
sudo systemctl restart nginx.service