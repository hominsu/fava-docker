FROM debian:bookworm AS builder

ARG FAVA_VERSION

ENV BUILD_DEPS="\
    build-essential \
    libxml2-dev     \
    libxslt-dev     \
    python3         \
    libpython3-dev  \
    python3-pip     \
    python3-venv    \
    "

RUN apt-get -yqq update &&  \
    apt-get install -yq --no-install-recommends ${BUILD_DEPS} &&  \
    apt-get autoremove -y &&  \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/

ENV PATH="/app/bin:$PATH"
RUN python3 -mvenv /app

ENV REQUIREMENTS="\
    beancount-periodic      \
    fava==${FAVA_VERSION}   \
    fava-dashboards         \
    fava-investor           \
    fava-plugins            \
    fava-portfolio-returns  \
    "

RUN pip3 install --no-cache-dir ${REQUIREMENTS} && \
    pip3 uninstall -y pip &&  \
    find /app -name __pycache__ -exec rm -rf -v {} +

FROM gcr.io/distroless/python3-debian12
COPY --from=builder /app /app

ENV BEANCOUNT_FILE=""
ENV FAVA_HOST="0.0.0.0"
ENV PATH="/app/bin:$PATH"

EXPOSE 5000

ENTRYPOINT ["fava"]
