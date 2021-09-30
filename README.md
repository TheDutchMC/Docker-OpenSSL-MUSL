# OpenSSL MUSL for Docker
The reason for this image is quite simple: A lot of my Rust programs require OpenSSL and are compiled MUSL (Because Alpine), and recompiling on CI every time I want to compile the program takes a while

## Usage
```dockerfile
FROM docker-registry.k8s.array21.dev/openssl-musl:latest AS OPENSSL

FROM ubuntu:latest

# Copy the files OpenSSL files
COPY --from=OPENSSL /musl /musl

# Tell your linker where to find OpenSSL
ENV PKG_CONFIG_ALLOW_CROSS=1
ENV OPENSSL_STATIC=true
ENV OPENSSL_DIR=/musl
```