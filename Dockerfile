FROM golang:1.11

COPY entrypoint.sh .

ENTRYPOINT ["./entrypoint.sh"]
