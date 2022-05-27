#!/bin/bash

set -euo pipefail

echo "Setting up bash_profile"
cat $HOME/.bash_aliases | grep source\ \$HOME/PhpstormProjects/mikes-devbox/bash_profile > /dev/null 2>&1 || {
  echo "source \$HOME/PhpstormProjects/mikes-devbox/bash_profile" >> $HOME/.bash_aliases
  echo "Added bash_profile to .bash_aliases"
}

echo "Sourcing aliases"
source $HOME/.bash_aliases

chmod +x $BOX_DIR/bin/*

echo "Installing dependencies"
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update
sudo apt install -y \
  git \
  guake \
  php8.1

sudo cp $BOX_DIR/systemd/trex.service /etc/systemd/system/trex.service
sudo systemctl daemon-reload
sudo systemctl enable trex
sudo systemctl start trex

mkdir -p tmp

google-chrome --version > /dev/null 2>&1 || {
  printf "\n\nInstalling Chrome\n\n"
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P tmp
  sudo apt install -y ./tmp/google-chrome-stable_current_amd64.deb
}

docker --version > /dev/null 2>&1 || {
  printf "\n\nInstalling docker\n\n"
  sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io
  sudo docker run hello-world
}

DOCKER_COMPOSE_VERSION=1.29.2
set +euo pipefail
DC_ACTUAL_VERSION=$(docker-compose --version)
set -euo pipefail
if [[ $DC_ACTUAL_VERSION != *"$DOCKER_COMPOSE_VERSION"* ]]
then
  printf "\n\nInstalling docker-compose\n\n"
  sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  docker-compose --version
fi

nvm --version > /dev/null 2>&1 || {
  printf "\n\nInstalling nvm\n\n"
  curl -sL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh -o tmp/install_nvm.sh
  bash tmp/install_nvm.sh
  source $HOME/.bashrc
  export NVM_DIR=$HOME/.nvm
  source $NVM_DIR/nvm.sh
  nvm install --lts
  node --version
}

aws --help > /dev/null 2>&1 || {
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  mv awscliv2.zip tmp/awscliv2.zip
  unzip tmp/awscliv2.zip -d tmp
  sudo ./tmp/aws/install
  aws --help
}

terraform -help > /dev/null 2>&1 || {
  sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
  sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  sudo apt-get update && sudo apt-get install terraform
}

rustc --version > /dev/null 2>&1 || {
  curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
}

composer --version > /dev/null 2>&1 || {
  $BOX_DIR/bin/install-composer
}

rm -rf tmp

cp -v $HOME/PhpstormProjects/mikes-devbox/autostart/* $HOME/.config/autostart/

pgrep guake > /dev/null 2>&1 || {
  guake > /dev/null 2>&1 &
}
