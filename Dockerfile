FROM ubuntu:xenial-20200916

ENV AWSCLI_VERSION='2.0.59'

RUN apt-get update && \
  apt-get install -y curl jq unzip && \
  apt-get clean

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip" -o "awscliv2.zip" && \
  unzip awscliv2.zip && \
  ./aws/install

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]