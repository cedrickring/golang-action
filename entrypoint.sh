#!/bin/sh

set -eu

WORKDIR="/go/src/github.com/${GITHUB_REPOSITORY}"
# create go work dir
mkdir -p ${WORKDIR}
# copy all files from workspace to work dir
cp -R /github/workspace/* ${WORKDIR}
# cd into the work dir and run all commands from there
cd ${WORKDIR}

sh -c "$*"