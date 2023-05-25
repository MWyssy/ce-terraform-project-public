#! /bin/bash
sudo apt update
sudo apt install -y nodejs
sudo apt install -y npm
sudo npm install pm2 -g
git clone https://MWyssy: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@github.com/MWyssy/ce-load-balancing-node-api.git
cd ce-load-balancing-node-api/app
npm install
pm2 start src/index.js