#!/bin/sh

set -e

if [ -z "${IMPORT}" ]; then
  IMPORT="${GITHUB_REPOSITORY}"
fi
WORKDIR="${GOPATH}/src/github.com/${IMPORT}"

# Go can only find dependencies if they're under $GOPATH/src.
# GitHub Actions mounts your repository outside of $GOPATH.
# So symlink the repository into $GOPATH, and then cd to it.
mkdir -p `dirname ${WORKDIR}`
ln -s ${PWD} ${WORKDIR}
cd ${WORKDIR}

sh -c "$*"