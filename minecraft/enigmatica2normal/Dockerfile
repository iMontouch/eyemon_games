FROM java:8

MAINTAINER iMontouch <imontouch@gmail.com>

RUN apt-get install -y wget unzip
RUN addgroup --gid 1234 minecraft
RUN adduser --disabled-password --home=/data --uid 1234 --gid 1234 --gecos "minecraft user" minecraft

RUN mkdir /tmp/feed-the-beast && cd /tmp/feed-the-beast && \
 wget -c https://misc.imontou.ch/Enigmatica2Server-1.77.zip -O enigmatica_server.zip && \
 unzip enigmatica_server.zip && \
 rm enigmatica_server.zip && \
 chown -R minecraft /tmp/feed-the-beast && \
 chown -R minecraft /data

COPY start.sh /start.sh
RUN chmod +x /start.sh

USER minecraft

VOLUME /data
WORKDIR /data

EXPOSE 25565

CMD ["/start.sh"]

ENV MOTD "Mittelerde MC Enigmatica 2 Expert"
ENV LEVEL world

LABEL traefik.enable true
LABEL traefik.frontend.rule Host:e2n.eyemon.de,
