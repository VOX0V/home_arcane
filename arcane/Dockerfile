# Arcane is copied from its official manager image and run as a native
# process inside the Home Assistant add-on container (not as nested Docker).
FROM ghcr.io/getarcaneapp/manager:latest AS arcane
FROM ghcr.io/home-assistant/base-debian:trixie-2026.04.0

RUN apt-get update \
    && apt-get install -y --no-install-recommends nginx openssl ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /app /data /run/nginx /tmp/nginx

COPY --from=arcane /app/ /app/
COPY rootfs /
RUN chmod +x /etc/cont-init.d/*.sh /etc/services.d/*/run /etc/services.d/*/finish \
    && chmod +x /app/arcane

ENV PORT=3552 \
    ENVIRONMENT=production \
    ARCANE_IN_CONTAINER=true \
    GIN_MODE=release \
    DATA_DIR=/data

LABEL org.opencontainers.image.title="Home Assistant App: Arcane" \
      org.opencontainers.image.description="Arcane manager for remote Docker environments" \
      org.opencontainers.image.source="https://github.com/getarcaneapp/arcane" \
      org.opencontainers.image.licenses="BSD-3-Clause"
