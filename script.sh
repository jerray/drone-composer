#!/bin/sh

GIT_PRIVATE_KEY=""

if [ -n "${PLUGIN_GIT_PRIVATE_KEY}" ]; then
    GIT_PRIVATE_KEY=$PLUGIN_GIT_PRIVATE_KEY
elif [ -n "${PLUGIN_USER_PRIVATE_KEY}" ]; then
    GIT_PRIVATE_KEY=$PLUGIN_USER_PRIVATE_KEY
fi

function configureGitURLByHost() {
    local host=$1
    git config --global url."git@${host}:".insteadOf https://${host}/
    ssh-keyscan ${host} >> ~/.ssh/known_hosts
}

function useSSHInsteadOfHTTPS() {
    if [ -n "${PLUGIN_GIT_SERVER_HOSTS}" ]; then
        export IFS=","
        for host in ${PLUGIN_GIT_SERVER_HOSTS}; do
            configureGitURLByHost $host
        done
    fi
}

function configureSSHPrivateKey() {
    echo "${GIT_PRIVATE_KEY}" > ~/.ssh/id_rsa
    chmod 600 ~/.ssh/id_rsa
}

function configureAuth() {
    if [ -n "{$PLUGIN_COMPOSER_AUTH}" ]; then
        echo $PLUGIN_COMPOSER_AUTH > ~/.composer/auth.json
    fi
}

function configurePackagist() {
    if [ -n "${PLUGIN_COMPOSER_REPO_PACKAGIST}" ]; then
        composer config -g repo.packagist compser ${PLUGIN_COMPOSER_REPO_PACKAGIST}
    fi
}

if [ -n "${GIT_PRIVATE_KEY}" ]; then
    configureSSHPrivateKey
    useSSHInsteadOfHTTPS
fi


if [ -n "${PLUGIN_CHDIR}" ]; then
    cd ${PLUGIN_CHDIR}
fi

configureAuth
configurePackagist

composer -vv install --ignore-platform-reqs
