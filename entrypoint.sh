#!/usr/bin/env bash
set -xe

###################
#### VARIABLES ####
###################
GITHUB_RELEASES_URL=https://github.com/elastic/apm-agent-php/releases/download
BUILD_RELEASES_FOLDER=_GENERATED/downloaded/releases

###################
#### FUNCTIONS ####
###################
function download() {
    package=$1
    folder=$2
    url=$3
    mkdir -p "${folder}"
    wget -q https://artifacts.elastic.co/GPG-KEY-elasticsearch -O "${folder}/GPG-KEY-elasticsearch"
    wget -q "${url}/${package}" -O "${folder}/${package}"
    wget -q "${url}/${package}.sha512" -O "${folder}/${package}.sha512"
    wget -q "${url}/${package}.asc" -O "${folder}/${package}.asc"
    cd "${folder}" || exit
    gpg --import "GPG-KEY-elasticsearch"
    shasum -a 512 -c "${package}.sha512"
    gpg --verify "${package}.asc" "${package}"
    cd -
}

function validate_if_agent_is_enabled() {
    ## Validate if the elastic php agent is enabled
    if ! php -m | grep -q 'elastic' ; then
        echo 'Extension has not been installed.'
        exit 1
    fi
}

function run_app_in_loop() {
    while :
    do
        php /repo_root/sample_app.php
    	echo "Press [CTRL+C] to stop..."
    	sleep 1
    done
}

##############
#### MAIN ####
##############
echo 'Starting entrypoint.sh main...'

PACKAGE=apm-agent-php_${VERSION}_all.deb
download "${PACKAGE}" "${BUILD_RELEASES_FOLDER}" "${GITHUB_RELEASES_URL}/v${VERSION}"
dpkg-sig --verify "${BUILD_RELEASES_FOLDER}/${PACKAGE}"
dpkg -i "${BUILD_RELEASES_FOLDER}/${PACKAGE}"

validate_if_agent_is_enabled

run_app_in_loop

echo 'entrypoint.sh main done'

