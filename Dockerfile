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
    ./create_keys.sh && \
    mv keys /etc/tmate-keys && \
    ./autogen.sh && \
    ./configure CFLAGS="-D_GNU_SOURCE" && \
    make -j && \
    cp tmate-slave /bin/tmate-slave && \
    apk del build-dependencies && \
    rm -rf /src

FROM alpine:latest
ENV PORT 2222
RUN apk add --no-cache ncurses-dev libevent-dev msgpack-c-dev libssh-dev openssh
ADD message.sh /tmp/message.sh
ADD tmate-slave.sh /tmate-slave.sh
COPY --from=0 /bin/tmate-slave /bin/tmate-slave
COPY --from=0 /etc/tmate-keys /etc/tmate-keys
CMD /bin/sh /tmp/message.sh && /bin/tmate-slave -k /etc/tmate-keys/ -p $PORT
