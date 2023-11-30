FROM alpine:3.18 AS build

ARG TELEGRAM_BOT_API_GIT_REF

RUN apk add --no-cache alpine-sdk cmake git gperf linux-headers ninja openssl-dev zlib-dev
WORKDIR /usr/local/src/telegram-bot-api
RUN git clone --recursive https://github.com/tdlib/telegram-bot-api.git .
RUN if [ ! -z $TELEGRAM_BOT_API_GIT_REF ]; then git checkout $TELEGRAM_BOT_API_GIT_REF; fi
WORKDIR build
RUN cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX:PATH=.. -G Ninja ..
RUN cmake --build . --target install
RUN strip ../bin/*

FROM alpine:3.18

COPY --from=build /usr/local/src/telegram-bot-api/bin/ /usr/local/bin/

RUN apk add --no-cache libstdc++ openssl

USER nobody
WORKDIR /telegram-bot-api
VOLUME /telegram-bot-api
EXPOSE 8081
ENTRYPOINT ["/usr/local/bin/telegram-bot-api", "--local"]
