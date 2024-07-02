FROM bash:alpine3.20

RUN apk update && apk add parallel aria2

COPY . /docker

RUN chmod +x /docker/download.sh

ENTRYPOINT [ "/docker/download.sh" ]
