FROM golang:1.10

LABEL name="Golang Action"
LABEL maintainer="Cedric Kring"
LABEL version="1.1.1"
LABEL repository="https://github.com/cedrickring/golang-action"

LABEL com.github.actions.name="Golang Action"
LABEL com.github.actions.description="Run Golang commands"
LABEL com.github.actions.icon="box"
LABEL com.github.actions.color="blue"

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
