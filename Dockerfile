# ==============================================================================
# Monster Lab - Production Web Dockerfile
# Serves the offline-first Flutter Web PWA via lightweight, hardened Nginx Alpine
# ==============================================================================

FROM nginx:alpine

LABEL maintainer="Monster Lab Team <support@monsterlab.org>"
LABEL org.opencontainers.image.title="Monster Lab Web"
LABEL org.opencontainers.image.description="Educational Arduino & Electronics Studio Web PWA"
LABEL org.opencontainers.image.version="0.0.3"

# Install curl for container health check
RUN apk add --no-cache curl

# Copy custom Nginx configuration optimized for Flutter SPA and PWA caching
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

# Copy compiled Flutter web release bundle
COPY build/web /usr/share/nginx/html

# Expose HTTP port
EXPOSE 80

# Container health monitoring
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/healthz || exit 1

# Start Nginx server in foreground
CMD ["nginx", "-g", "daemon off;"]
