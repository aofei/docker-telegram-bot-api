FROM ubuntu:20.04

LABEL maintainer="aofei@aofeisheng.com"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update \
	&& apt upgrade -y \
	&& apt install cmake g++ git gperf libssl-dev make zlib1g-dev -y \
	&& apt autoremove -y \
	&& apt autoclean

RUN git clone --recursive https://github.com/tdlib/telegram-bot-api.git /tmp/telegram-bot-api \
	&& mkdir /tmp/telegram-bot-api/build \
	&& cd /tmp/telegram-bot-api/build \
	&& cmake -DCMAKE_BUILD_TYPE=Release .. \
	&& cmake --build . --target install

WORKDIR /srv/telegram-bot-api

CMD telegram-bot-api \
	--local \
	--api-id=$TELEGRAM_API_ID \
	--api-hash=$TELEGRAM_API_HASH \
	--http-port=80 \
	--http-stat-port=8080 \
	--dir=/srv/telegram-bot-api \
	--temp-dir=/tmp/telegram-bot-api
