FROM alpine

LABEL maintainer="aofei@aofeisheng.com"

ARG GIT_COMMIT_HASH=master

RUN export BUILD_ONLY_PKGS="alpine-sdk cmake git gperf linux-headers openssl-dev zlib-dev" \
	&& apk add --no-cache $BUILD_ONLY_PKGS \
	&& git clone --recursive https://github.com/tdlib/telegram-bot-api.git /tmp/telegram-bot-api \
	&& cd /tmp/telegram-bot-api \
	&& git checkout $GIT_COMMIT_HASH \
	&& mkdir build \
	&& cd build \
	&& cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr/local .. \
	&& cmake --build . --target install \
	&& rm -rf /tmp/* \
	&& apk del $BUILD_ONLY_PKGS

RUN apk add --no-cache libstdc++ openssl zlib

ENTRYPOINT ["telegram-bot-api"]
