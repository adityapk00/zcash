#!/bin/bash

echo "Building Linux"
make clean >/dev/null
./zcutil/build.sh -j$(nproc) >/dev/null
strip src/zcashd
strip src/zcash-cli
cp src/zcashd ../zcash/artifacts/
cp src/zcash-cli ../zcash/artifacts/
