FROM debian:trixie-slim AS builder

RUN apt-get update \
  && apt-get -y install --no-install-recommends \
    ca-certificates \
    curl \
    apt-transport-https \
  && update-ca-certificates --fresh \
  && curl -sSL https://dtcooper.github.io/raspotify/key.asc -o /usr/share/keyrings/raspotify_key.asc \
  && chmod 644 /usr/share/keyrings/raspotify_key.asc \
  && echo 'deb [signed-by=/usr/share/keyrings/raspotify_key.asc] https://dtcooper.github.io/raspotify raspotify main' > /etc/apt/sources.list.d/raspotify.list \
  && apt-get update \
  && apt-get -y --no-install-recommends install raspotify

FROM debian:trixie-slim

COPY --from=builder /etc/raspotify /etc/raspotify
COPY --from=builder /usr/bin/librespot /usr/bin/librespot
COPY --from=builder /usr/share/doc/raspotify /usr/share/doc/raspotify

RUN apt-get update \
  && apt-get --no-install-recommends -y install \
    libasound2 \
    alsa-utils \
    libpulse0 \
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

CMD ["/usr/bin/librespot"]