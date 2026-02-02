FROM python:alpine AS builder

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

FROM python:alpine

RUN apk add --no-cache s6-overlay &&  \
    rm -rf /var/cache/apk/* &&  \
    hash -r

COPY --from=builder /app /app
COPY rootfs/ /

ENV PATH="/app/bin:$PATH"   \
    FAVA_HOST="localhost"   \
    FAVA_PORT="5000"        \
    BEANCOUNT_FILE=""

ENTRYPOINT [ "/init" ]
