#!/usr/bin/env bash

# Miniature World Sawmill Installer
#
# This script installs the PiMediaSync application and sets up all of the
# components (video and configuration) necessary to run the installation.
#
# All variables declared with 'export' are used by the PiMediaSync setup script.

set -e

if [ $(whoami) != 'root' ]; then
    echo 'Must be run as root.'
    exit 1
fi

HOMEDIR=${HOMEDIR:-/root}
WORKDIR=${HOMEDIR}/sawmill
SAWMILL_VERSION=${SAWMILL_VERSION:-2.1.1}

rm -rf ${WORKDIR}
mkdir -p ${WORKDIR}/video

# use wget to download the files from the repository since raspberry pi doesn't
# support git large file storage
wget -P ${WORKDIR} https://raw.githubusercontent.com/${GITHUB_HOST}/mini-world-sawmill-display/${SAWMILL_VERSION}/sawmill_config.py
wget -P ${WORKDIR} https://raw.githubusercontent.com/${GITHUB_HOST}/mini-world-sawmill-display/${SAWMILL_VERSION}/PIMEDIASYNC_VERSION
wget -P ${WORKDIR}/video https://github.com/${GITHUB_HOST}/mini-world-sawmill-display/raw/${SAWMILL_VERSION}/video/sawmill.mov

# set up pimediasync
SAWMILL_CONFIG_FILE=${SAWMILL_CONFIG_FILE:-sawmill_config.py}
export APPLICATION_FLAGS="-c${WORKDIR}/${SAWMILL_CONFIG_FILE}"
export PIMEDIASYNC_VERSION=${PIMEDIASYNC_VERSION:-$(cat ${WORKDIR}/PIMEDIASYNC_VERSION)}
export PIHOSTNAME='miniworld-sawmill'
wget -O - https://raw.githubusercontent.com/${GITHUB_HOST}/PiMediaSync/${PIMEDIASYNC_VERSION}/scripts/install.sh | bash

# install the video in the location used by pimediasync
PIMEDIASYNC_DIR=${PIMEDIASYNC_DIR:-/opt/pimediasync} # defined during pimediasync installation
ln -s ${WORKDIR}/video ${PIMEDIASYNC_DIR}/video

echo 'Installation finished. Reboot the device to start the application.'

set +e
