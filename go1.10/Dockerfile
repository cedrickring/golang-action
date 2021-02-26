FROM golang:1.10

LABEL name="Golang Action"
LABEL maintainer="Cedric Kring"
LABEL version="1.7.0"
LABEL repository="https://github.com/cedrickring/golang-action"

LABEL com.github.actions.name="Golang Action"
LABEL com.github.actions.description="Run Golang commands"
LABEL com.github.actions.icon="box"
LABEL com.github.actions.color="blue"

# Install dep and check sha256 checksum matches for version 0.5.4 https://github.com/golang/dep/releases/tag/v0.5.4
RUN set -eux; \
  curl -L -s https://github.com/golang/dep/releases/download/v0.5.4/dep-linux-amd64 -o "$GOPATH/bin/dep"; \
  echo "40a78c13753f482208d3f4bea51244ca60a914341050c588dad1f00b1acc116c $GOPATH/bin/dep" | sha256sum -c -; \
  chmod +x "${GOPATH}/bin/dep";

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
