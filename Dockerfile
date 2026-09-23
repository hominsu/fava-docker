FROM python:alpine AS base

RUN addgroup --system --gid 1001 fava &&    \
    adduser --system --uid 1001 --ingroup fava fava &&  \
    hash -r

FROM base AS builder

ARG VIRTUAL_ENV=/app

ENV BUILD_DEPS="\
    bison       \
    flex        \
    gcc         \
    g++         \
    uv          \
    "

RUN apk add --no-cache ${BUILD_DEPS} &&    \
    rm -rf /var/cache/apk/*

ENV UV_COMPILE_BYTECODE=1   \
    UV_LINK_MODE=copy

COPY --link requirements.txt /tmp/requirements.txt

RUN --mount=type=cache,target=/root/.cache/uv \
    uv venv ${VIRTUAL_ENV} &&   \
    uv pip install --python "${VIRTUAL_ENV}/bin/python" -r /tmp/requirements.txt

FROM base AS runner

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apk add --no-cache s6-overlay &&  \
    rm -rf /var/cache/apk/*

COPY --from=builder --link --chown=fava:fava /app /app
COPY --link rootfs/ /

ENV PATH="/app/bin:$PATH"   \
    FAVA_HOST="0.0.0.0"     \
    FAVA_PORT="5000"        \
    BEANCOUNT_FILE=""

VOLUME [ "/data" ]
ENTRYPOINT [ "/init" ]
