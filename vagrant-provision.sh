#!/usr/bin/env bash

###
# Updating
###
echo "Updating OS"
apt-get update
apt-get -y dist-upgrade

###
# Install dependences
###
echo "Installing Dependencies"
apt-get update
apt-get -y install tmux zsh git build-essential mosh ruby-dev python-dev libperl-dev libncurses5-dev exuberant-ctags \
  libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev \
  clang libicu-dev wget

# Use zsh
echo "Switching to ZSH"
chsh -s "$(which zsh)"

# VIM specific for lua support
echo "installing VIM with lua"
echo "Getting dependencies..."
apt-get -y install liblua5.2-dev luajit libluajit-5.2

echo "Linking lua"
mkdir /usr/include/lua5.2/include
mv /usr/include/lua5.2/*.h /usr/include/lua5.2/include/

# ln -s /usr/bin/luajit-2.0.* /usr/bin/luajit

echo "Creating /usr/share/src"
mkdir -p /usr/share/src

# echo "Setting up permissions for /usr/share"
# chown -R "$USER" /usr/share/src

