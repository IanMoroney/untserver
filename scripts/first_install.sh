#!/bin/bash

BASEPATH=/home/untserver
LSGMuntserverCFG=${BASEPATH}/lgsm/config-lgsm/untserver/untserver.cfg

# source $scriptsDir/check_space.sh

if [ "${space,,}" == 'no'  ]; then
    echo "[ERROR] Not enough space, needed: 12 GB, available: $freeGB GB"
    exit
fi

echo "[INFO] Executing LinuxGSM script to get default files"

# Start to create default files
./untserver

echo "[INFO] Changing Unturned server version to install"

# If missing file create
if [ ! -f $LSGMuntserverCFG ]
then
    mkdir -p ${BASEPATH}/lgsm/config-lgsm/untserver/
    touch $LSGMuntserverCFG
fi

# Check version

if [ "${VERSION,,}" == 'stable'  ] || [ "${VERSION,,}" == 'public'  ]
    then
        if grep -R "branch" "$LSGMuntserverCFG"
            then
                sed -i "s/branch=.*/branch=\"\"/" $LSGMuntserverCFG
                echo "[INFO] Version changed to ${VERSION,,}"
            else
                echo "[INFO] Selecting Unturned ${VERSION,,} version"
        fi
    else
        if grep -R "branch" "$LSGMuntserverCFG"
            then
                sed -i 's/branch=.*/branch="$VERSION"/' $LSGMuntserverCFG
            else
                echo branch='"-beta $VERSION"' >> $LSGMuntserverCFG
                echo "[INFO] Selecting Unturned ${VERSION,,} version"
        fi
fi

echo "[INFO] Installing Unturned ${VERSION,,} version"

# Install Unturned Server

./untserver auto-install

echo "[INFO] The server have been installed."

echo "If this file is missing, server will be re-installed" > serverfiles/DONT_REMOVE.txt

echo "To prevent double mod install at first start" > serverfiles/MOD_BLOCK.txt

# Creating Unturned mod folder
# mkdir /home/untserver/serverfiles/Mods

# source $scriptsDir/Mods/mods_install.sh
