#! /bin/bash
sudo apt-get update
sudo /usr/bin/git clone https://MWyssy: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@github.com/MWyssy/ce-terraform-project-html-host.git
sudo apt-get install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
sudo rm /etc/nginx/sites-enabled/default
sudo rm /usr/share/nginx/html/index.html
sudo rm /etc/nginx/nginx.conf
sudo mv ~/ce-terraform-project-html-host/index.html /usr/share/nginx/html/index.html
sudo mv ~/ce-terraform-project-html-host/styles.css /usr/share/nginx/html/styles.css
sudo mv ~/ce-terraform-project-html-host/nginx.conf /etc/nginx/nginx.conf
sudo systemctl restart nginx.service