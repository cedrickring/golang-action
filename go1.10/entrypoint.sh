#!/bin/sh

set -e

if [ -z "${IMPORT}" ]; then
  IMPORT="${GITHUB_REPOSITORY}"
fi
WORKDIR="${GOPATH}/src/github.com/${IMPORT}"

# Go can only find dependencies if they're under $GOPATH/src.
# GitHub Actions mounts your repository outside of $GOPATH.
# So symlink the repository into $GOPATH, and then cd to it.
mkdir -p "$(dirname "${WORKDIR}")"
ln -s "${PWD}" "${WORKDIR}"
cd "${WORKDIR}"

# If a command was specified with `args="..."`, then run it.  Otherwise,
# look for something useful to run.
if [ $# -eq 0 ]; then
  if [ -r Makefile ]; then
    make
  else
    go build ./...
    go test ./...
  fi
else
  sh -c "$*"
fi
