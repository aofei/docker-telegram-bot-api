FROM alpine AS build

ARG TELEGRAM_BOT_API_GIT_REF

RUN apk add --no-cache alpine-sdk cmake git gperf linux-headers ninja openssl-dev zlib-dev
RUN git clone --recursive https://github.com/tdlib/telegram-bot-api.git /usr/local/src/telegram-bot-api \
	&& cd /usr/local/src/telegram-bot-api \
	&& if [ ! -z $TELEGRAM_BOT_API_GIT_REF ]; then git checkout $TELEGRAM_BOT_API_GIT_REF; fi \
	&& mkdir build \
	&& cd build \
	&& cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX:PATH=.. -G Ninja .. \
	&& cmake --build . --target install \
	&& strip ../bin/*

FROM alpine

COPY --from=build /usr/local/src/telegram-bot-api/bin/ /usr/local/bin/

RUN apk add --no-cache libstdc++ openssl

CMD ["/usr/local/bin/telegram-bot-api", "--local"]
