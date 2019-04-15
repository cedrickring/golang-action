FROM golang:1.12

LABEL name="Golang Action"
LABEL maintainer="Cedric Kring"
LABEL version="1.3.0"
LABEL repository="https://github.com/cedrickring/golang-action"

LABEL com.github.actions.name="Golang Action"
LABEL com.github.actions.description="Run Golang commands"
LABEL com.github.actions.icon="box"
LABEL com.github.actions.color="blue"

# Install dep and check sha256 checksum matches for version 0.5.0 https://github.com/golang/dep/releases/tag/v0.5.0
RUN set -eux; \
  curl -L -s https://github.com/golang/dep/releases/download/v0.5.0/dep-linux-amd64 -o "$GOPATH/bin/dep"; \
  echo "287b08291e14f1fae8ba44374b26a2b12eb941af3497ed0ca649253e21ba2f83 $GOPATH/bin/dep" | sha256sum -c -; \
  chmod +x "${GOPATH}/bin/dep";

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
