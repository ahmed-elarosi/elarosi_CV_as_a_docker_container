#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────
#  build-and-push.sh
#  Usage: ./build-and-push.sh [VERSION]
#  Default version: 1.0.0
# ─────────────────────────────────────────────────────────────────
set -euo pipefail

# ── CHANGE THIS to your Docker Hub username ───────────────────────
DOCKER_USER="ahmedelarosi"
# ─────────────────────────────────────────────────────────────────

IMAGE_NAME="ahmed-elarosi-cv"
VERSION="${1:-1.0.0}"
FULL="${DOCKER_USER}/${IMAGE_NAME}"
BUILD_DATE="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
GIT_COMMIT="$(git rev-parse --short HEAD 2>/dev/null || echo 'local')"

echo ""
echo "  ┌─────────────────────────────────────────┐"
echo "  │  Building ${FULL}:${VERSION}"
echo "  └─────────────────────────────────────────┘"
echo ""

docker build \
  --build-arg VERSION="${VERSION}"       \
  --build-arg BUILD_DATE="${BUILD_DATE}" \
  --build-arg GIT_COMMIT="${GIT_COMMIT}" \
  --tag "${FULL}:${VERSION}"             \
  --tag "${FULL}:latest"                 \
  .

echo ""
echo "  ✅  Build done: ${FULL}:${VERSION}"
echo ""

# ── Optional: vulnerability scan (install trivy first) ──────────
if command -v trivy &>/dev/null; then
  echo "  🔍  Scanning for HIGH/CRITICAL vulnerabilities..."
  trivy image --severity HIGH,CRITICAL "${FULL}:${VERSION}"
fi

# ── Push ─────────────────────────────────────────────────────────
echo ""
read -rp "  Push to Docker Hub? [y/N] " confirm
if [[ "${confirm}" =~ ^[Yy]$ ]]; then
  docker push "${FULL}:${VERSION}"
  docker push "${FULL}:latest"
  echo ""
  echo "  🚀  Pushed to Docker Hub!"
  echo ""
  echo "  ─── Share these commands with your IT team ───────────"
  echo ""
  echo "  docker pull ${FULL}:${VERSION}"
  echo ""
  echo "  docker run -d -p 8080:8080 \\"
  echo "    --read-only \\"
  echo "    --tmpfs /var/cache/nginx \\"
  echo "    --tmpfs /var/run \\"
  echo "    ${FULL}:${VERSION}"
  echo ""
  echo "  Then open: http://localhost:8080"
  echo "  ──────────────────────────────────────────────────────"
fi