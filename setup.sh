#!/usr/bin/env bash

set -e

# verify that the script is run as root
if [ $(whoami) != 'root' ]; then
    echo 'Must be run as root.'
    exit 1
fi

# set the working directory and repository source
HOMEDIR=${HOMEDIR:-/opt}
WORKDIR=${HOMEDIR}/sawmill
SAWMILL_VERSION=${SAWMILL_VERSION:-v2.1.3}
GITHUB_HOST=${GITHUB_HOST:-limbicmedia}

# clean the working directory
rm -rf ${WORKDIR}
mkdir -p ${WORKDIR}
mkdir ${WORKDIR}/video

# download the needed files from the repository
wget -P ${WORKDIR} https://raw.githubusercontent.com/${GITHUB_HOST}/mini-world-sawmill-display/${SAWMILL_VERSION}/sawmill_config.py
wget -P ${WORKDIR} https://raw.githubusercontent.com/${GITHUB_HOST}/mini-world-sawmill-display/${SAWMILL_VERSION}/PIMEDIASYNC_VERSION
wget -P ${WORKDIR}/video https://github.com/${GITHUB_HOST}/mini-world-sawmill-display/raw/${SAWMILL_VERSION}/video/sawmill.mov

# set up the pimediasync configuration
export APPLICATION_FLAGS="-c ${WORKDIR}/sawmill_config.py"
export PIMEDIASYNC_VERSION=$(cat ${WORKDIR}/PIMEDIASYNC_VERSION)
export PIMEDIASYNC_WORKDIR='/opt/pimediasync'

# run the pimediasync installation script
wget -O - https://raw.githubusercontent.com/${GITHUB_HOST}/PiMediaSync/${PIMEDIASYNC_VERSION}/scripts/install.sh | bash

# install the video
ln -s ${WORKDIR}/video ${PIMEDIASYNC_WORKDIR}/video

echo 'Installation finished. Reboot the device to start the application.'

set +e
