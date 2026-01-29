FROM python:slim-bookworm AS builder

ARG FAVA_VERSION

RUN apt-get update && apt-get install -y --no-install-recommends \
	build-essential	\
        flex	\
        bison	\
        && rm -rf /var/lib/apt/lists/ \
        && apt-get autoremove -y && apt-get autoclean -y

RUN pip install --root-user-action ignore --prefix="/install" fava==${FAVA_VERSION}

FROM gcr.io/distroless/python3-debian12

COPY --from=builder /install /usr/local

ENV FAVA_HOST="0.0.0.0"

EXPOSE 5000

CMD ["fava"]
