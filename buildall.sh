#!/bin/bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -v|--version)
    VERSION="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [ -z "$VERSION" ]
then
    echo "Please specify the git version tag to build as --version v4.1.0"
    exit 1
fi

mkdir -p artifacts/mac
mkdir -p artifacts/linux
mkdir -p artifacts/win

# Delete the zcash local directory if it exists for the build
rm -rf ./zcash

docker build --tag adityapk00/zcash:latest docker

# Build for Mac
if [[ "$OSTYPE" == "darwin"* ]]; then
    git clone https://github.com/zcash/zcash
    cd zcash
    git checkout $VERSION
    ./zcutil/clean.sh
    CONFIGURE_FLAGS="--disable-tests --disable-mining --disable-bench" ./zcutil/build.sh -j$(nproc) && strip src/zcashd && strip src/zcash-cli && cp src/zcashd ../artifacts/mac && cp src/zcash-cli ../artifacts/mac
    cd ..
fi

# Build for linux in docker using ECC's ubuntu 16.04 image
docker run --rm -v $(pwd):/opt/zcash electriccoinco/zcashd-build-ubuntu1604 bash -c "cd /opt && git clone https://github.com/zcash/zcash zcash-linux && cd zcash-linux && git checkout $VERSION && CONFIGURE_FLAGS=\"--disable-tests --disable-mining --disable-bench\" ./zcutil/build.sh -j$(nproc) && strip src/zcashd && strip src/zcash-cli && cp src/zcashd src/zcash-cli /opt/zcash/artifacts/linux/"

# Build for win in docker, using ECC's debian10 image, which is what they use on their CI as well. 
docker run --rm -v $(pwd):/opt/zcash adityapk00/zcash:latest bash -c "cd /opt && git clone https://github.com/zcash/zcash zcash-win && cd zcash-win && git checkout $VERSION && CONFIGURE_FLAGS=\"--disable-tests --disable-mining --disable-bench\" HOST=x86_64-w64-mingw32 ./zcutil/build.sh -j$(nproc) && strip src/zcashd.exe && strip src/zcash-cli.exe && cp src/zcashd.exe src/zcash-cli.exe /opt/zcash/artifacts/win/"
