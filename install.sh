#!/bin/bash

cd "~"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install wget
brew install php@7.2
brew install git
brew install diff-so-fancy
brew tap homebrew/cask-fonts
brew cask install font-fira-code
brew install fswatch
brew install n
brew install bat
brew install zsh
zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
chsh -s /bin/zsh
cd $ZPREZTODIR
git clone --recurse-submodules https://github.com/belak/prezto-contrib contrib
cd "~"
git clone git@github.com:satrun77/moo-command.git ~/workspace/moo-command
cd ~/workspace/moo-command
git checkout develop
./install.sh

mv ~/.git ~/workspace/dotfiles
