FROM golang:1.15

LABEL name="Golang Action"
LABEL maintainer="Cedric Kring"
LABEL version="v2.0.0"
LABEL repository="https://github.com/cedrickring/golang-action"

LABEL com.github.actions.name="Golang Action"
LABEL com.github.actions.description="Run Golang commands"
LABEL com.github.actions.icon="box"
LABEL com.github.actions.color="blue"

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
