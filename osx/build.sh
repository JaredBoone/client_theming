#!/bin/bash
export PATH=/usr/local/Qt-5.6.2/bin/:$PATH
export OPENSSL_ROOT_DIR=$(brew --prefix openssl)
export WORKING_DIR=~/workspace/temp
export CLIENT_THEMING_DIR=~/workspace/nextcloud-client_theming

# Cleanup
cd $WORKING_DIR
sudo rm -rf build-mac
sudo rm -rf owncloud-client
sudo rm -rf install

# Clone the desktop client code
cd $WORKING_DIR
git clone --recursive https://github.com/JaredBoone/owncloud-client.git

if [ ! -d "$WORKING_DIR/owncloud-client" ]; then
  echo "Err: Could not clone owncloud-client"
  exit
fi

cd owncloud-client
git checkout 2.3.2
git submodule update --recursive

# Build qtkeychain
cd $WORKING_DIR/owncloud-client/src/3rdparty/qtkeychain
cmake -DCMAKE_OSX_SYSROOT="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk" -DCMAKE_OSX_DEPLOYMENT_TARGET=10.8 -DCMAKE_INSTALL_PREFIX=$WORKING_DIR/install -DCMAKE_PREFIX_PATH=/usr/local/Qt-5.6.2 .
sudo make install

# Build the client
cd $WORKING_DIR
cp $CLIENT_THEMING_DIR/osx/dsa_pub.pem owncloud-client/admin/osx/sparkle/
rm -rf build-mac
mkdir build-mac
cd build-mac
cmake -DCMAKE_OSX_SYSROOT="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk" -DCMAKE_OSX_DEPLOYMENT_TARGET=10.8 -DCMAKE_INSTALL_PREFIX=$WORKING_DIR/install -DCMAKE_PREFIX_PATH=/usr/local/Qt-5.6.2 -D SPARKLE_INCLUDE_DIR=~/Library/Frameworks/Sparkle.framework/ -D SPARKLE_LIBRARY=~/Library/Frameworks/Sparkle.framework/ -D OEM_THEME_DIR=$CLIENT_THEMING_DIR/shipdrivetheme -DWITH_CRASHREPORTER=ON -DNO_SHIBBOLETH=1 -DMIRALL_VERSION_BUILD=1 ../owncloud-client -Wno-dev
make
sudo make install
sudo $WORKING_DIR/owncloud-client/admin/osx/sign_app.sh $WORKING_DIR/install/shipdrive.app DA30C098685993A9C483F89D06F2E46B467034A6 PZR8TPXW34
sudo ./admin/osx/create_mac.sh ../install/ . 053762F12204E448C66A0B3FF6BEBC4E8865DC23

# Generate a sparkle signature for the tbz
openssl dgst -sha1 -binary < $WORKING_DIR/install/*.tbz | openssl dgst -dss1 -sign $CLIENT_THEMING_DIR/osx/dsa_priv.pem | openssl enc -base64 > $WORKING_DIR/sig.txt
sudo mv $WORKING_DIR/sig.txt $WORKING_DIR/install/signature.txt
