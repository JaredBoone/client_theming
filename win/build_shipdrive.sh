#!/bin/bash
export CLIENT_THEMING_DIR=~/workspace/nextcloud-client_theming
export WORKING_DIR=~/workspace/temp

cd $WORKING_DIR
#sudo rm -rf owncloud-client
#git clone --recursive https://github.com/JaredBoone/owncloud-client.git

if [ ! -d "$WORKING_DIR/owncloud-client" ]; then
  echo "Err: Could not clone owncloud-client"
  exit
fi

cd owncloud-client
git checkout 2.2.4
git submodule update --recursive

docker-machine start default
eval $(docker-machine env)
docker build -t nextcloud-client-win32:2.2.4 $WORKING_DIR/owncloud-client/admin/win/docker/
docker run -v "$CLIENT_THEMING_DIR:/home/user/" -v "$WORKING_DIR/owncloud-client:/home/user/owncloud-client" nextcloud-client-win32:2.2.4 /home/user/win/build.sh
cp $WORKING_DIR/owncloud-client/build/SHIPdrive-2.2.4.1-setup.exe ~/Desktop/