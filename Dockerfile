FROM ubuntu:focal
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y \
    musl-tools \
    libssl-dev \
    build-essential \
    wget

WORKDIR /

RUN ln -s /usr/include/x86_64-linux-gnu/asm /usr/include/x86_64-linux-musl/asm \
    && ln -s /usr/include/asm-generic /usr/include/x86_64-linux-musl/asm-generic \
    && ln -s /usr/include/linux /usr/include/x86_64-linux-musl/linux

RUN mkdir /musl

RUN wget https://github.com/openssl/openssl/archive/OpenSSL_1_1_1f.tar.gz
RUN tar zxvf OpenSSL_1_1_1f.tar.gz

WORKDIR /openssl-OpenSSL_1_1_1f/

RUN CC="musl-gcc -fPIE -pie" ./Configure no-shared no-async --prefix=/musl --openssldir=/musl/ssl linux-x86_64
RUN make depend
RUN make -j$(nproc)
RUN make installd