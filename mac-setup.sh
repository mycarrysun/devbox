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
  brew install terraform
}
