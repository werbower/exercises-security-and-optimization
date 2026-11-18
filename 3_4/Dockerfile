FROM docker:stable

RUN apk add bash
RUN apk add --no-cache git

COPY builder.sh ./builder
ENTRYPOINT [ "bash", "builder" ]

