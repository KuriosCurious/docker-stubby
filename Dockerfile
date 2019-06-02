FROM alpine

RUN apk add git libssl1.1 autoconf automake libtool g++ openssl-dev yaml-dev make

RUN git clone https://github.com/getdnsapi/getdns.git
WORKDIR getdns
RUN git checkout master && git submodule update --init

RUN libtoolize -ci && autoreconf -fi && mkdir build
WORKDIR build
RUN ../configure --without-libidn --without-libidn2 --enable-stub-only --with-stubby \
        && make && make install

COPY stubby.yml /usr/local/etc/stubby/stubby.yml

EXPOSE 53/udp

CMD [ "stubby", "-l" ]