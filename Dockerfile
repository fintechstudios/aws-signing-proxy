## aws-signing-proxy
FROM golang:1.14-buster as build

WORKDIR /workspace

# Copy the Go Modules manifests
ADD go.mod go.mod
ADD go.sum go.sum

# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
RUN go mod download

ADD main.go /workspace

RUN go build -o aws-signing-proxy

# Use the stable debian slim image as the final image
FROM debian:stable-slim

MAINTAINER FTS Engineering <engineering@fintechstudios.com>

# Add CA Certs
RUN apt-get update \
  && apt-get install -y ca-certificates \
  && rm -rf /var/cache/apt
# Add executable
COPY --from=build /workspace/aws-signing-proxy /

ENTRYPOINT ["/aws-signing-proxy"]
