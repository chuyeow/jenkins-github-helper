FROM tianon/github-hub@sha256:06e91dd548c8d49995ca2affc7c842417d61ebb2ff2638beb56c10da2620211b

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
