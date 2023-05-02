#!/usr/bin/env zsh
set -euo pipefail

echo "Setting up bash_profile"
cat $HOME/.zprofile | grep source\ \$HOME/code/devbox/.zprofile > /dev/null 2>&1 || {
  echo "source \$HOME/code/devbox/.zprofile" >> $HOME/.zprofile
  echo "Added zprofile to .zprofile"
}

echo "Sourcing aliases"
source $HOME/.zprofile

chmod +x $BOX_DIR/bin/*
chmod +x $BOX_DIR/mac-setup.sh

set +e
git --version > /dev/null 2>&1 || {
  brew install git
}

foreman --version > /dev/null 2>&1 || {
  brew install foreman
}

nvm > /dev/null 2>&1 || {
  brew install nvm
}

az > /dev/null 2>&1 || {
  brew install azure-cli
}

aws --version > /dev/null 2>&1 || {
  brew install awscli
}

java --version > /dev/null 2>&1 || {
  brew install java
}

terraform --version > /dev/null 2>&1 || {
  brew install tfenv
}

bun --version > /dev/null 2>&1 || {
  curl https://bun.sh/install | bash
}

docker-credential-helper-ecr > /dev/null 2>&1 || {
  brew install docker-credential-helper-ecr
  DOCKER_HELPER_PATH=$(echo -n "$(brew --prefix docker-credential-helper-ecr)")
  echo "export PATH=\"\$PATH:$DOCKER_HELPER_PATH\"" >> ~/.zprofile
}

mkdir -p ~/code
cd ~/code

if [[ ! -d ./frontend ]]
then
  git clone git@github.com:lower-financial/frontend.git
fi

if [[ ! -d ./backend ]]
then
  git clone git@github.com:lower-financial/backend.git
fi

if [[ ! -d ./platform ]]
then
  git clone git@github.com:lower-financial/platform.git
fi

if [[ ! -d ./infrastructure ]]
then
  git clone git@github.com:lower-financial/infrastructure.git
fi

cd -