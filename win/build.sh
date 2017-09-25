#!/bin/bash

useradd user -u ${1:-1000}
su - user << EOF
  cd /home/user/
  rm -rf /home/user/owncloud-client/build
  mkdir /home/user/owncloud-client/build
  cd /home/user/owncloud-client/build
  /home/user/owncloud-client/admin/win/download_runtimes.sh
  cmake -DCMAKE_TOOLCHAIN_FILE=/home/user/owncloud-client/admin/win/Toolchain-mingw32-openSUSE.cmake\
  -DWITH_CRASHREPORTER=ON \
  -DOEM_THEME_DIR=/home/user/shipdrivetheme \
  -DMIRALL_VERSION_BUILD=1 \
  /home/user/owncloud-client
  make -j4
  make package
  ctest .
EOF
