#!/usr/bin/env bash

###
# Permissions
###
echo "Setting up permissions for /usr/share"
sudo chown -R "$USER":"$USER" /usr/share/src

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
  --with-lua-prefix=/usr/include/lua5.2 \
  --enable-cscope

make
sudo make install

###
# Swift Installation
###
echo "Installing Swift"
cd /usr/share/src || exit

SWIFT_DOWNLOAD_FOLDER="swift-4.0.2-RELEASE"
SWIFT_VERSION=$(echo "$SWIFT_DOWNLOAD_FOLDER" | tr '[:upper:]' '[:lower:]')
# SWIFT_VERSION="$SWIFT_DOWNLOAD_FOLDER"
SWIFT_SNAPSHOT_NAME="$SWIFT_DOWNLOAD_FOLDER-ubuntu16.04"
echo "Downloading Swift $SWIFT_VERSION"
wget "https://swift.org/builds/$SWIFT_VERSION/ubuntu1604/$SWIFT_DOWNLOAD_FOLDER/$SWIFT_SNAPSHOT_NAME.tar.gz"
echo "Downloading Signature"
wget "https://swift.org/builds/$SWIFT_VERSION/ubuntu1604/$SWIFT_DOWNLOAD_FOLDER/$SWIFT_SNAPSHOT_NAME.tar.gz.sig"

echo "Getting keys"
wget -q -O - https://swift.org/keys/all-keys.asc | gpg --import -
gpg --keyserver hkp://pool.sks-keyservers.net --refresh-keys Swift

echo "Verifying Downloaded Package"
gpg --verify "$SWIFT_SNAPSHOT_NAME".tar.gz.sig

if [[ $? -ne 0 ]]; then
  echo "Swift installation failure - Signature failed verification"
  exit 1
fi

echo "Unpacking swift"
tar zxf "$SWIFT_SNAPSHOT_NAME".tar.gz
echo "Cleaning up downloads"
rm "$SWIFT_SNAPSHOT_NAME".tar.gz
rm "$SWIFT_SNAPSHOT_NAME".tar.gz.sig
mv "$SWIFT_SNAPSHOT_NAME" swift

###
# Install NodeJS
###
curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
sudo apt-get install -y nodejs

# echo "Installing node.js"
# cd /usr/share/src || exit

# echo "Downloading NodeJS"
# NODE_VERSION="v4.5.0"
# NODE_FILE="node-$NODE_VERSION"
# wget "https://nodejs.org/dist/$NODE_VERSION/$NODE_FILE.tar.gz"

# tar zxf "$NODE_FILE".tar.gz
# rm "$NODE_FILE".tar.gz
# pushd "$NODE_FILE"
# echo "Installing NodeJS"
# ./configure && make && sudo make install
# popd
# echo "Cleaning up after install"
# rm -r "$NODE_FILE"

