#!/bin/sh

set -e

# PROJECT_PATH specifies the subdirectory in the working directory that the Go project is
if [ -z "${PROJECT_PATH}" ]; then
  PROJECT_PATH="."
fi

cd "${WORKDIR}/${PROJECT_PATH}"

# If a command was specified with `args: "..."`, then run it.  Otherwise,
# look for something useful to run.
if [ $# -eq 0 ] || [ "$*" = "" ]; then
  if [ -r Makefile ]; then
    make
  else
    if [ -r go.mod ]; then
      export GO111MODULE=on
      # Check if using vendored dependencies
      if [ -d "vendor" ]; then
        export GOFLAGS="-mod=vendor"
      else
        # Ensure no go.mod changes are made that weren't committed
        export GOFLAGS="-mod=readonly"
      fi
    fi
    go build ./...
    go test ./...
  fi
else
  sh -c "$*"
fi
