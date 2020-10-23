FROM python:alpine3.12

ENV AWSCLI_VERSION='1.18'

RUN pip3 --no-cache-dir install awscli==${AWSCLI_VERSION}
RUN apk add --no-cache jq

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]