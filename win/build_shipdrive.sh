#!/bin/bash
export CLIENT_THEMING_DIR=~/workspace/nextcloud-client_theming
export WORKING_DIR=~/workspace/temp

cd $WORKING_DIR
sudo rm -rf owncloud-client
git clone --recursive https://github.com/JaredBoone/owncloud-client.git

if [ ! -d "$WORKING_DIR/owncloud-client" ]; then
  echo "Err: Could not clone owncloud-client"
  exit
fi

cd owncloud-client
git checkout 2.3.2
git submodule update --recursive

docker-machine start default
eval $(docker-machine env)
docker pull alfageme/docker-owncloud-client-win32:snapshot
docker run -v "$CLIENT_THEMING_DIR:/home/user/" -v "$WORKING_DIR/owncloud-client:/home/user/owncloud-client" alfageme/docker-owncloud-client-win32:snapshot /home/user/win/compile_client.sh -o shipdrivetheme -b 1 /home/user/owncloud-client
cp $WORKING_DIR/owncloud-client/build/SHIPdrive-2.3.2.1-setup.exe ~/Desktop/