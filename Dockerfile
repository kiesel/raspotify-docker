FROM debian:trixie-slim AS builder

RUN apt-get update \
  && apt-get -y install --no-install-recommends \
    alsa-utils \
    apt-transport-https \
    ca-certificates \
    curl \
    libasound2 \
    libpulse0 \
  && update-ca-certificates --fresh \
  && curl -sSL https://dtcooper.github.io/raspotify/key.asc -o /usr/share/keyrings/raspotify_key.asc \
  && chmod 644 /usr/share/keyrings/raspotify_key.asc \
  && echo 'deb [signed-by=/usr/share/keyrings/raspotify_key.asc] https://dtcooper.github.io/raspotify raspotify main' > /etc/apt/sources.list.d/raspotify.list \
  && apt-get update \
  && apt-get -y --no-install-recommends install raspotify \
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

CMD ["/usr/bin/librespot"]