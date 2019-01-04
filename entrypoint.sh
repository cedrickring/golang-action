#!/bin/sh

set -eu

WORKDIR="/go/src/github.com/${GITHUB_REPOSITORY}"
# create go work dir
echo "mkdir -p ${WORKDIR}"
mkdir -p ${WORKDIR}
# copy all files from workspace to work dir
echo "cp -R /github/workspace/* ${WORKDIR}"
cp -R /github/workspace/* ${WORKDIR}
# cd into the work dir and run all commands from there
echo "cd ${WORKDIR}"
cd ${WORKDIR}

sh -c "go $*"
