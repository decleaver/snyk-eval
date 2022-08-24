FROM artifactory.cloud.cms.gov/docker/golang:alpine3.15 as build

COPY . /app

WORKDIR /app/grype

RUN mkdir /app/grype/tmp && \
    apk --no-cache add ca-certificates git && \
    go build -o ./tmp/

FROM artifactory.cloud.cms.gov/docker/alpine:3.15

RUN apk add python3

COPY --from=build /app/grype/tmp/grype /usr/local/bin/

LABEL org.opencontainers.image.title="grype"
LABEL org.opencontainers.image.description="A vulnerability scanner for container images and filesystems"
LABEL org.opencontainers.image.vendor="Anchore, Inc."
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL io.artifacthub.package.readme-url="https://raw.githubusercontent.com/anchore/grype/main/README.md"
LABEL io.artifacthub.package.logo-url="https://user-images.githubusercontent.com/5199289/136855393-d0a9eef9-ccf1-4e2b-9d7c-7aad16a567e5.png"
LABEL io.artifacthub.package.license="Apache-2.0"

ENTRYPOINT ["/usr/local/bin/grype"]
