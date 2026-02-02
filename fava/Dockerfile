FROM debian:bookworm AS builder
ENV UV_COMPILE_BYTECODE=1 UV_LINK_MODE=copy

ENV BUILD_DEPS="\
    build-essential \
    python3         \
    libpython3-dev  \
    "

RUN apt-get -yqq update &&  \
    apt-get install -yq --no-install-recommends ${BUILD_DEPS} &&  \
    apt-get autoremove -y &&  \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/

ARG VIRTUAL_ENV=/app

COPY requirements.txt .
RUN --mount=from=ghcr.io/astral-sh/uv:latest,source=/uv,target=/bin/uv \
    uv venv ${VIRTUAL_ENV} &&   \
    uv pip install --no-cache -r requirements.txt &&   \
    find ${VIRTUAL_ENV} -name __pycache__ -exec rm -rf -v {} + &&   \
    rm requirements.txt

FROM gcr.io/distroless/python3-debian12
COPY --from=builder /app /app

ENV PATH="/app/bin:$PATH"

ENV BEANCOUNT_FILE=""
ENV FAVA_PORT="5000"
ENV FAVA_HOST="localhost"

ENTRYPOINT ["fava"]
