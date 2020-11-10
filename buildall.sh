#!/bin/bash

mkdir -p artifacts/mac
mkdir -p artifacts/linux
mkdir -p artifacts/win

# Build for Mac
if [[ "$OSTYPE" == "darwin"* ]]; then
    ./zcutil/clean.sh
    CONFIGURE_FLAGS="--disable-tests --disable-mining --disable-bench" ./zcutil/build.sh -j$(nproc)
    strip src/zcashd
    strip src/zcash-cli
    cp src/zcashd artifacts/mac
    cp src/zcash-cli artifacts/mac
fi

# Build for linux in docker using ECC's ubuntu 16.04 image
docker run --rm -v $(pwd):/opt/zcash electriccoinco/zcashd-build-ubuntu1604 bash -c "cd /opt && git clone https://github.com/adityapk00/zcash zcash-linux && cd zcash-linux && git checkout zecwallet-build && CONFIGURE_FLAGS=\"--disable-tests --disable-mining --disable-bench\" ./zcutil/build.sh -j$(nproc) && strip src/zcashd && strip src/zcash-cli && cp src/zcashd src/zcash-cli /opt/zcash/artifacts/linux/"

# Build for win in docker, using ECC's debian10 image, which is what they use on their CI as well. 
docker run --rm -v $(pwd):/opt/zcash electriccoinco/zcashd-build-debian10 bash -c "cd /opt && git clone https://github.com/adityapk00/zcash zcash-win && cd zcash-win && git checkout zecwallet-build && CONFIGURE_FLAGS=\"--disable-tests --disable-mining --disable-bench\" HOST=x86_64-w64-mingw32 ./zcutil/build.sh -j$(nproc) && strip src/zcashd.exe && strip src/zcash-cli.exe && cp src/zcashd.exe src/zcash-cli.exe /opt/zcash/artifacts/win/"
