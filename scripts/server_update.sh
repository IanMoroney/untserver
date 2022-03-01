#!/bin/bash
./untserver update

if [ "${VERSION,,}" == 'stable'  ]
    then
        sed -i 's/branch=".*"/branch=""/' /home/untserver/lgsm/config-lgsm/untserver/common.cfg
    else
        sed -i "s/branch=".*"/branch="\"${VERSION,,}"\"/" /home/untserver/lgsm/config-lgsm/untserver/common.cfg
        echo "[INFO] Server version changed to: ${VERSION,,}"
fi

./untserver update

echo "[INFO] The server have been updated to ${VERSION,,}"

# source $scriptsDir/Mods/mods_install.sh

echo "[INFO] The server mods have been updated to latest version, if the server crash, check mod compatibilites"
