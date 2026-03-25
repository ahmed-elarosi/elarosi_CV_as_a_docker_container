# ────────────────────────────────────────────────────────────────
#  Ahmed Elarosi — Bilingual CV + Documents
#  Base  : nginx:alpine  (minimal attack surface, ~5 MB)
#  Port  : 8080  (non-privileged)
#  User  : appuser (UID 1001, non-root)
# ────────────────────────────────────────────────────────────────

FROM nginx:alpine

# ── Build-time labels (versioning & traceability) ───────────────
ARG VERSION=1.0.0
ARG BUILD_DATE
ARG GIT_COMMIT

LABEL org.opencontainers.image.title="ahmed-elarosi-cv"
LABEL org.opencontainers.image.description="Ahmed Elarosi – Bilingual CV (EN/DE) + Documents"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.revision="${GIT_COMMIT}"
LABEL org.opencontainers.image.authors="ahmed_elarosi@proton.me"

# ── Non-root user ────────────────────────────────────────────────
RUN addgroup -g 1001 -S appgroup && \
    adduser  -u 1001 -S appuser -G appgroup

# ── Hardened nginx config ────────────────────────────────────────
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# ── Copy CV site + all PDF documents ────────────────────────────
COPY html/ /usr/share/nginx/html/

# ── Fix permissions ──────────────────────────────────────────────
RUN chown -R appuser:appgroup /usr/share/nginx/html && \
    chown -R appuser:appgroup /var/cache/nginx       && \
    chown -R appuser:appgroup /var/log/nginx         && \
    touch /var/run/nginx.pid                         && \
    chown appuser:appgroup /var/run/nginx.pid

# ── Run as non-root ──────────────────────────────────────────────
USER appuser

EXPOSE 8080

# ── Health check ─────────────────────────────────────────────────
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget -qO- http://localhost:8080/health || exit 1

CMD ["nginx", "-g", "daemon off;"]