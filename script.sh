#!/bin/bash

cd /home/ubuntu
## update the server
sudo apt update
sudo apt upgrade -y

## install the nginx
sudo apt install nginx -y
sudo apt update -y
sudo apt install ruby-full -y
sudo apt install wget

wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"


## install node 16.16.0
nvm install v16.16.0

## install pm2 globally
npm install pm2@latest -g

## revert npm version from latest to 6.14.1
npm i -g npm@6.14.1



## install codedeploy agent.
wget -P /home/ubuntu https://aws-codedeploy-ap-south-1.s3.ap-south-1.amazonaws.com/latest/install
sudo chmod +x ./install
sudo ./install auto


## install aws cli so we can install the .env file
wget -P /home/ubuntu "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
unzip awscli-exe-linux-x86_64.zip
rm awscli-exe-linux-x86_64.zip
sudo ./aws/install


## clean up
DIR="/home/ubuntu/api.mymango.video"
if [ -d "$DIR" ]; then
  echo "${DIR} exists"
else
  echo "Creating ${DIR}"
  mkdir ${DIR}
fi
sudo chmod -R 0755 /home/ubuntu/api.mymango.video

## make sure the permission are of type ubuntu user
sudo chown -R ubuntu:ubuntu /home/ubuntu/.nvm || true
sudo chown -R ubuntu:ubuntu /home/ubuntu/aws || true
sudo chown -R ubuntu:ubuntu /home/ubuntu/api.mymango.video || true
