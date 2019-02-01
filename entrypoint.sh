#!/bin/sh

set -e

if [ -z "${IMPORT}" ]; then
  IMPORT="${GITHUB_REPOSITORY}"
fi
WORKDIR="/go/src/github.com/${IMPORT}"
# create go work dir
mkdir -p ${WORKDIR}
# copy all files from workspace to work dir
cp -R /github/workspace/* ${WORKDIR}
# cd into the work dir and run all commands from there
cd ${WORKDIR}

sh -c "$*"