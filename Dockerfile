# Hub Dockerfile commands stolen from https://github.com/tianon/dockerfiles/blob/682bb2a/github-hub/Dockerfile.
FROM debian:stretch-slim

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		ca-certificates \
		git \
		openssh-client \
		vim-nox \
		wget \
	&& rm -rf /var/lib/apt/lists/*

ENV LANG C.UTF-8

WORKDIR /opt/hub
ENV PATH /opt/hub/bin:$PATH

# https://github.com/github/hub/releases
ENV GITHUB_HUB_VERSION 2.14.2

RUN set -ex; \
	\
	dpkgArch="$(dpkg --print-architecture)"; \
	case "$dpkgArch" in \
		amd64) arch='amd64' ;; \
		arm64) arch='arm64' ;; \
		armhf) arch='arm' ;; \
		i386) arch='386' ;; \
		*) echo >&2 "error: unknown architecture '$dpkgArch'"; exit 1 ;; \
	esac; \
	wget -O hub.tgz "https://github.com/github/hub/releases/download/v${GITHUB_HUB_VERSION}/hub-linux-${arch}-${GITHUB_HUB_VERSION}.tgz"; \
	tar -xvf hub.tgz --strip-components 1 -C /usr/local; \
	rm -v hub.tgz; \
	\
	hub --version

WORKDIR /opt/jq/bin
ENV PATH /opt/jq/bin:$PATH

# https://github.com/stedolan/jq/releases
ENV JQ_VERSION 1.6

RUN set -ex; \
    \
    dpkgArch="$(dpkg --print-architecture)"; \
	case "$dpkgArch" in \
		amd64) arch='linux64' ;; \
		i386) arch='linux32' ;; \
		*) echo >&2 "error: unknown architecture '$dpkgArch'"; exit 1 ;; \
	esac; \
    wget -O jq "https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-${arch}"; \
	chmod +x jq; \
    jq --version

CMD ["hub"]
