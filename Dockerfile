FROM golang:1.10

LABEL version="1.1.0"
LABEL repository="https://github.com/cedrickring/golang-action"
LABEL maintainer="Cedric Kring"

LABEL com.github.actions.name="Golang Action"
LABEL com.github.actions.description="Run Golang commands"
LABEL com.github.actions.icon="box"
LABEL com.github.actions.color="blue"

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
