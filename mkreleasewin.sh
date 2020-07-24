#!/bin/bash

echo "Building Windows"
make clean > /dev/null
HOST=x86_64-w64-mingw32 ./zcutil/build.sh -j$(nproc) >/dev/null
strip src/zcashd.exe
strip src/zcash-cli.exe
cp src/zcashd.exe ../zcash/artifacts/
cp src/zcash-cli.exe ../zcash/artifacts/
