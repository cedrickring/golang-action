#!/bin/sh

set -e

if [ -z "${IMPORT}" ]; then
  IMPORT="${GITHUB_REPOSITORY}"
fi
WORKDIR="${GOPATH}/src/github.com/${IMPORT}"

# PROJECT_PATH specifies the subdirectory in the working directory that the Go project is
if [ -z "${PROJECT_PATH}" ]; then
  PROJECT_PATH="."
fi

# Go can only find dependencies if they're under $GOPATH/src.
# GitHub Actions mounts your repository outside of $GOPATH.
# So symlink the repository into $GOPATH, and then cd to it.
mkdir -p "$(dirname "${WORKDIR}")"
ln -s "${PWD}" "${WORKDIR}"
cd "${WORKDIR}/${PROJECT_PATH}"

# If a command was specified with `args="..."`, then run it.  Otherwise,
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
    else
      if [ -r Gopkg.toml ]; then
        # Check if using vendored dependencies
        if [ -d "vendor" ]; then
          # Check that dep is in sync with /vendor dependencies and that running dep ensure doesn't result in modifications to Gopkg.lock/Gopkg.toml
          "$GOPATH/bin/dep" ensure && "$GOPATH/bin/dep" check
          git_workspace_status="$(git status --porcelain)"
          if [ -n "${git_workspace_status}" ]; then
            echo "Unexpected changes were found in dep /vendored. Please run $(dep ensure) and commit changes:";
            echo "${git_workspace_status}";
            exit 1;
          fi
        else
          # Run dep ensure to download and sync dependencies
          "$GOPATH/bin/dep" ensure
        fi
      fi
    fi
    go build ./...
    go test ./...
  fi
else
  sh -c "$*"
fi
