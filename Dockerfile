ARG libtsduck=libtsduck-static

FROM alpine:3.14 AS builder
ARG tsduck_url=https://github.com/tsduck/tsduck/archive/refs/tags/v3.27-2438.tar.gz
RUN \
  apk add --no-cache \
    bash \
    curl \
    g++ \
    linux-headers \
    make \
    tar \
    && \
  curl -fsSL "${tsduck_url}" \
    | tar xz -C /tmp --strip=1 --wildcards --no-wildcards-match-slash \
      '*/src/libtsduck' \
      '*/src/tsplugins' \
      '*/src/tstools' \
      '*/src/utest' \
      '*/build' \
      '*/Makefile*' \
      && \
  echo \
    exec make \
      '$@' \
      BINDIR=../../bin \
      NOCURL=1 \
      NODTAPI=1 \
      NOPCSC=1 \
      NOSRT=1 \
      NOTELETEXT=1 \
      STATIC=true \
    > make && \
  apk del --purge \
    curl \
    tar

FROM builder AS libtsduck-builder
RUN \
  sh make -C /tmp/src/libtsduck install SYSPREFIX=/libtsduck && \
  rm -rf make /tmp/*

FROM scratch AS libtsduck-static
COPY --from=libtsduck-builder /libtsduck /usr
LABEL maintainer="https://github.com/ep76/docker-tsduck-static"

# Workaround for `COPY --from` not working with `ARG`
# (https://stackoverflow.com/a/63472135):
FROM ${libtsduck} AS libtsduck

FROM builder AS libtsduck-tester
COPY --from=libtsduck /usr/lib/libtsduck.* /usr/share/tsduck/* /tmp/bin/
RUN \
  sh make -C /tmp/src/utest && \
  rm -rf make /tmp/*

FROM builder AS tsduck-builder
COPY --from=libtsduck /usr/lib/libtsduck.* /tmp/bin/
COPY --from=libtsduck /usr/share /tsduck/share
RUN \
  sh make -C /tmp/src/tsplugins && \
  sh make -C /tmp/src/tstools install SYSPREFIX=/tsduck && \
  rm -rf make /tmp/*

FROM scratch AS tsduck-static
COPY --from=tsduck-builder /tsduck /usr
LABEL maintainer="https://github.com/ep76/docker-tsduck-static"
ENTRYPOINT [ "/usr/bin/tsp" ]
