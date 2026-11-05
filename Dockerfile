FROM golang:1.26 AS builder

WORKDIR /app

COPY main.go .

RUN CGO_ENABLED=0 go build \
    -trimpath \
    -ldflags="-s -w -buildid=" \
    -o hello main.go

FROM debian:bookworm-slim AS compressor

WORKDIR /tmp

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        xz-utils && \
    update-ca-certificates && \
    curl -fsSLO https://github.com/upx/upx/releases/download/v5.2.1/upx-5.2.1-amd64_linux.tar.xz && \
    tar -xJf upx-5.2.1-amd64_linux.tar.xz && \
    cp upx-5.2.1-amd64_linux/upx /usr/local/bin/upx && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/hello /hello

RUN upx --best --lzma /hello

FROM scratch

COPY --from=compressor /hello /hello

ENTRYPOINT ["/hello"]
