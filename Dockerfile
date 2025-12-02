FROM alpine:3.22 AS build

ARG TELEGRAM_BOT_API_GIT_REF=master

RUN apk add --no-cache alpine-sdk linux-headers cmake ninja gperf openssl-dev zlib-dev

WORKDIR /usr/local/src/telegram-bot-api
RUN git clone --recursive https://github.com/tdlib/telegram-bot-api.git .
RUN git checkout "${TELEGRAM_BOT_API_GIT_REF}"

WORKDIR build
RUN cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX:PATH=.. -G Ninja ..
RUN cmake --build . --target install
RUN strip ../bin/*

FROM alpine:3.22

COPY --from=build /usr/local/src/telegram-bot-api/bin/ /usr/local/bin/

RUN apk add --no-cache libstdc++ openssl

USER nobody
WORKDIR /telegram-bot-api
VOLUME /telegram-bot-api
EXPOSE 8081
ENTRYPOINT ["/usr/local/bin/telegram-bot-api", "--local"]
