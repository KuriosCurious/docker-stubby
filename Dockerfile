FROM alpine AS builder

RUN apk add git libssl1.1 autoconf automake libtool g++ openssl-dev yaml-dev make \
        && git clone https://github.com/getdnsapi/getdns.git \
        && cd getdns && git checkout master && git submodule update --init \
        && libtoolize -ci && autoreconf -fi && mkdir build \
        && cd build \
        && ../configure --without-libidn --without-libidn2 --enable-stub-only --with-stubby \
        && make && make install


FROM alpine

RUN apk add libssl1.1 libcrypto1.1 openssl yaml \
        && mkdir /usr/local/var && mkdir /usr/local/var/run

COPY --from=builder /usr/local/lib/libgetdns.so.10 /usr/local/lib/
COPY --from=builder /usr/local/bin/ /usr/local/bin/
COPY stubby.yml /usr/local/etc/stubby/stubby.yml

EXPOSE 53/udp

CMD [ "stubby", "-l" ]