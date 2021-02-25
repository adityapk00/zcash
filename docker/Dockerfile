FROM ubuntu:20.04
LABEL Description="Ubuntu 20.04 for zcash compilation"

RUN apt-get update && apt-get install -y git build-essential curl g++-mingw-w64-x86-64 gcc-mingw-w64-x86-64 libtinfo5 automake libtool bsdmainutils ncurses-dev unzip

RUN update-alternatives --set x86_64-w64-mingw32-gcc /usr/bin/x86_64-w64-mingw32-gcc-posix && \
    update-alternatives --set x86_64-w64-mingw32-g++ /usr/bin/x86_64-w64-mingw32-g++-posix