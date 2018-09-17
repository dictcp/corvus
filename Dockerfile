FROM buildpack-deps:stretch-scm
RUN apt-get update && apt-get install -y --no-install-recommends \
        g++ \
        gcc \
        libc6-dev \
        make \
        pkg-config \
        autoconf \
        git \
    && rm -rf /var/lib/apt/lists/*

ADD . /tmp/corvus
WORKDIR /tmp/corvus

RUN git submodule update --init
RUN make deps
RUN make
RUN cp /tmp/corvus/src/corvus /usr/local/bin/
RUN rm -rf /tmp/corvus

FROM debian:stretch

COPY --from=0 /usr/local/bin/corvus /usr/local/bin/corvus

CMD /usr/local/bin/corvus
EXPOSE 6380

