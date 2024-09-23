FROM ubuntu:bionic AS builder

ARG THRIFT_VERSION=0.21.0

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -y \
      curl \
      build-essential \
      libtool \
      pkg-config \
      automake \
      bison \
      flex \
      ;

WORKDIR /src
ADD checksums.txt /src/
ADD https://github.com/apache/thrift/archive/v${THRIFT_VERSION}.tar.gz /src/
RUN sha256sum --check --ignore-missing checksums.txt && \
    tar xf v${THRIFT_VERSION}.tar.gz --strip-components=1 && \
    ./bootstrap.sh && \
    ./configure --disable-debug --disable-tests --disable-libs && \
    make && \
    make install

FROM ubuntu:bionic

COPY --from=builder /usr/local/bin/thrift /usr/local/bin/thrift

ADD test.thrift /tmp/test.thrift
RUN thrift --gen go --gen java --gen py --gen js -o /tmp/ /tmp/test.thrift && \
    rm -rf /tmp/gen-* /tmp/test.thrift

WORKDIR /data

ENTRYPOINT ["/usr/local/bin/thrift"]
