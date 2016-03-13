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
chsh -s $(which zsh)

# VIM specific for lua support
echo "installing VIM with lua"
echo "Getting dependencies..."
apt-get -y install liblua5.1-dev luajit libluajit-5.1

echo "Linking lua"
mkdir /usr/include/lua5.1/include
mv /usr/include/lua5.1/*.h /usr/include/lua5.1/include/

# ln -s /usr/bin/luajit-2.0.* /usr/bin/luajit

###
# VIM Installation
###
echo "Creating /usr/share/src"
mkdir -p /usr/share/src
cd /usr/share/src || exit
echo "Cloning vim"
git clone https://github.com/vim/vim --depth 1
cd vim/src || exit
make distclean
./configure --with-features=huge \
  --enable-rubyinterp \
  --enable-largefile \
  --enable-pythoninterp \
  --with-python-config-dir=/usr/lib/python2.7/config \
  --enable-perlinterp \
  --enable-luainterp \
  --enable-gui=auto \
  --enable-fail-if-missing \
  --with-lua-prefix=/usr/include/lua5.1 \
  --enable-cscope

make
make install

###
# Swift Installation
###
echo "Installing Swift"
mkdir -p /usr/share/src
cd /usr/share/src || exit

echo "Downloading Swift 2.2"
echo "Snapshot from 2016-02-24 swift.org"
wget "https://swift.org/builds/swift-2.2-branch/ubuntu1404/swift-2.2-SNAPSHOT-2016-02-24-a/swift-2.2-SNAPSHOT-2016-02-24-a-ubuntu14.04.tar.gz"
wget "https://swift.org/builds/swift-2.2-branch/ubuntu1404/swift-2.2-SNAPSHOT-2016-02-24-a/swift-2.2-SNAPSHOT-2016-02-24-a-ubuntu14.04.tar.gz.sig"

echo "Getting keys"
wget -q -O - https://swift.org/keys/all-keys.asc | gpg --import -
gpg --keyserver hkp://pool.sks-keyservers.net --refresh-keys Swift

echo "Verifying Downloaded Package"
gpg --verify swift-2.2-SNAPSHOT-2016-02-24-a-ubuntu14.04.tar.gz.sig

if [[ $? -ne 0 ]]; then
  echo "Swift installation failure - Signature failed verification"
  exit 1
fi

echo "Unpacking swift"
tar zxf swift-2.2-SNAPSHOT-2016-02-24-a-ubuntu14.04.tar.gz 
echo "Cleaning up downloads"
rm swift-2.2-SNAPSHOT-2016-02-24-a-ubuntu14.04.tar.gz
rm swift-2.2-SNAPSHOT-2016-02-24-a-ubuntu14.04.tar.gz.sig
mv swift-2.2-SNAPSHOT-2016-02-24-a-ubuntu14.04 swift

###
# Install NodeJS
###
echo "Installing node.js"
mkdir -p /usr/share/src
cd /usr/share/src || exit

echo "Downloading NodeJS"
wget "https://nodejs.org/dist/v4.4.0/node-v4.4.0.tar.gz"

tar zxf node-v4.4.0.tar.gz
rm node-v4.4.0.tar.gz
pushd node-v4.4.0
echo "Installing NodeJS"
./configure && make && make install
popd
echo "Cleaning up after install"
rm -r node-v4.4.0

