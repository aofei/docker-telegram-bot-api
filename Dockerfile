FROM archlinux:latest

LABEL maintainer="aofei@aofeisheng.com"

RUN pacman -S base-devel cmake git gperf --noconfirm

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
