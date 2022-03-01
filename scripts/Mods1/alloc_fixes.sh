#!/bin/bash

MODS_FOLDER=/home/untserver/serverfiles/Mods

# Change DL_LINK depending on Unturned branch version
if [ "${VERSION,,}" == 'stable' ] || [ "${VERSION,,}" == 'public' ]; then
    DL_LINK="http://illy.bz/fi/7dtd/server_fixes.tar.gz"
elif [ "${VERSION,,}" == 'alpha19.6' ] || [ "${VERSION,,}" == 'alpha19.5' ]; then
    DL_LINK="http://illy.bz/fi/7dtd/server_fixes_v21_23_38.tar.gz"
elif [ "${VERSION,,}" == 'alpha19.0' ] || [ "${VERSION,,}" == 'alpha19.2' ] || [ "${VERSION,,}" == 'alpha19.3' ] || [ "${VERSION,,}" == 'alpha19.4' ]; then
    DL_LINK="http://illy.bz/fi/7dtd/server_fixes_v21_23_38.tar.gz"
elif [ "${VERSION,,}" == 'alpha18.4' ]; then
    DL_LINK="http://illy.bz/fi/7dtd/server_fixes_v20_23_33.tar.gz"
elif [ "${VERSION,,}" == 'alpha17.4' ]; then
    DL_LINK="http://illy.bz/fi/7dtd/server_fixes_v18_21_31.tar.gz"
elif [ "${VERSION,,}" == 'alpha16.4' ]; then
    DL_LINK="http://illy.bz/fi/7dtd/server_fixes_v14_17_26.tar.gz"
else
    echo "[Alloc Fixes] No version found compatible with version ${VERSION}"
    echo "[Alloc Fixes] If there is a compatible version check -> https://7dtd.illy.bz/wiki/Server%20fixes#aUnturnedvsModversioncompatibility and install it manually"
    echo "[Alloc Fixes] Omitting installation"
fi

downloadRelease() {
    curl $DL_LINK -SsL -o allocs.tar.gz
}

echo "[Alloc Fixes] Installing ${VERSION} version"

echo "[Alloc Fixes] Downloading release from $DL_LINK"

echo "[Alloc Fixes] Downloading files"

downloadRelease

echo "[Alloc Fixes] Extracting files"

mkdir -p allocs-temp
tar --strip-components=1 -xf allocs.tar.gz -C allocs-temp 

echo "[Alloc Fixes] Removing older version"

rm -rf $MODS_FOLDER/Allocs*

echo "[Alloc Fixes] Installing components"

mv allocs-temp/* $MODS_FOLDER

echo "[Alloc Fixes] Cleanup"

rm allocs.tar.gz
rm -rf allocs-temp

echo "[Alloc Fixes] Finished! ヽ(´▽\`)/"
