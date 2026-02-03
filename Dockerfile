FROM python:alpine AS base

RUN addgroup --system --gid 1001 fava &&    \
    adduser --system --uid 1001 fava &&     \
    hash -r

FROM base AS builder

ARG VIRTUAL_ENV=/app

COPY requirements.txt .

ENV BUILD_DEPS="\
    bison       \
    flex        \
    gcc         \
    g++         \
    uv          \
    "

ENV UV_COMPILE_BYTECODE=1   \
    UV_LINK_MODE=copy

RUN apk add --no-cache ${BUILD_DEPS} &&  \
    rm -rf /var/cache/apk/* &&  \
    uv venv ${VIRTUAL_ENV} &&   \
    uv pip install --no-cache -r requirements.txt &&   \
    find ${VIRTUAL_ENV} -name __pycache__ -exec rm -rf -v {} + &&   \
    hash -r

FROM base AS runner

RUN apk add --no-cache s6-overlay &&  \
    rm -rf /var/cache/apk/* &&  \
    hash -r

COPY --from=builder --chown=fava:fava /app /app
COPY rootfs/ /

ENV PATH="/app/bin:$PATH"   \
    FAVA_HOST="0.0.0.0"     \
    FAVA_PORT="5000"        \
    BEANCOUNT_FILE=""

VOLUME [ "/data" ]
ENTRYPOINT [ "/init" ]
