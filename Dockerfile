FROM alpine:latest
ADD backtrace.patch .
RUN apk add --no-cache --virtual build-dependencies \
        build-base \
        ca-certificates \
        bash \
        wget \
        git \
        openssh \
        libc6-compat \
        automake \
        autoconf \
        zlib-dev \
        libevent-dev \
        msgpack-c-dev \
        ncurses-dev \
        libexecinfo-dev \
        libssh-dev \
        libc6-compat \
        libssh \
        msgpack-c \
        ncurses-libs \
        libevent

RUN mkdir /src && \
    git clone https://github.com/tmate-io/tmate-slave.git /src/tmate-server && \
    cd /src/tmate-server && \
    git apply /backtrace.patch && \
    ./autogen.sh && \
    ./configure CFLAGS="-D_GNU_SOURCE" && \
    make -j && \
    cp tmate-slave /bin/tmate-slave && \
    apk del --no-cache build-dependencies

FROM alpine:latest
ENV PORT 2222
RUN apk add --no-cache ncurses-dev libevent-dev msgpack-c-dev libssh-dev openssh
ADD entrypoint.sh /bin/entrypoint.sh
ADD tmate-banner.sh /bin/tmate-banner.sh
COPY --from=0 /bin/tmate-slave /bin/tmate-server
COPY --from=0 /src/tmate-server/create_keys.sh /bin/create_keys.sh
ENTRYPOINT ["/bin/entrypoint.sh"]
CMD /bin/tmate-server -k /etc/tmate-keys/ -h $HOST -p $PORT
