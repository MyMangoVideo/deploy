#!/bin/bash


RED_COLOR="\033[0;31m"
YELLOW_COLOR="\033[0;33m"
GREEN_COLOR="\033[0;32m"
NO_COLOR="\033[0m"

err() {
    echo -e "${RED_COLOR} ERROR: $* ${NO_COLOR}" >> /dev/stderr
}

msg() {
    echo -e "${GREEN_COLOR} $* ${NO_COLOR}" >> /dev/stderr
}

warn() {
    echo -e "${YELLOW_COLOR} $* ${NO_COLOR}" >> /dev/stderr 
}

msg "moving into dir /home/ubuntu..."
cd /home/ubuntu

msg "running update and upgrade server..."
## update the server
sudo apt update
sudo apt upgrade -y

msg "upgrade complete..."


msg "installing nginx, wget and ruby..."
## install the nginx
sudo apt install nginx -y
sudo apt update -y
sudo apt install ruby-full -y
sudo apt install wget
msg "package installation done."


msg "running nvm..."
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
msg "nvm installation done..."

msg "installing nodejs v1"
## install node 16.16.0
nvm install v16.16.0
msg "node 16 installation done..."

msg "installing pm2"
## install pm2 globally
npm install pm2@latest -g


msg "setting npm to 6.14.1"
## revert npm version from latest to 6.14.1
npm i -g npm@6.14.1
msg "npm installation done..."

msg "installging codedeploy...."
## install codedeploy agent.
wget -P /home/ubuntu https://aws-codedeploy-ap-south-1.s3.ap-south-1.amazonaws.com/latest/install

msg "changing permissions..."
sudo chmod +x ./install

msg "installing the codedeploy...."
sudo ./install auto

msg "codedeploy done.."



msg "installing aws command..."
## install aws cli so we can install the .env file
curl  "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscli.zip"
unzip awscli.zip
rm awscli.zip

msg "installing aws command..."
sudo ./aws/install



msg "creating working folder..."
## clean up
DIR="/home/ubuntu/api.mymango.video"
if [ -d "$DIR" ]; then
  warn "${DIR} exists"
else
  msg "Creating ${DIR}"
  mkdir ${DIR}
fi

msg "updating the chown for the current details...."
sudo chmod -R 0755 /home/ubuntu/api.mymango.video

## make sure the permission are of type ubuntu user
sudo chown -R ubuntu:ubuntu /home/ubuntu/.nvm || true
sudo chown -R ubuntu:ubuntu /home/ubuntu/aws || true
sudo chown -R ubuntu:ubuntu /home/ubuntu/api.mymango.video || true


msg "process completed...."
