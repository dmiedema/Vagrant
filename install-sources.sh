#!/usr/bin/env bash

###
# VIM Installation
###
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
sudo make install

###
# Swift Installation
###
echo "Installing Swift"
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
cd /usr/share/src || exit

echo "Downloading NodeJS"
wget "https://nodejs.org/dist/v4.4.0/node-v4.4.0.tar.gz"

tar zxf node-v4.4.0.tar.gz
rm node-v4.4.0.tar.gz
pushd node-v4.4.0
echo "Installing NodeJS"
./configure && make && sudo make install
popd
echo "Cleaning up after install"
rm -r node-v4.4.0

