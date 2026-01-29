FROM python:slim AS builder

ARG FAVA_VERSION

RUN pip install --root-user-action ignore --prefix="/install" fava==${FAVA_VERSION}

FROM gcr.io/distroless/python3-debian12

COPY --from=builder /install /usr/local

ENV FAVA_HOST="0.0.0.0"

EXPOSE 5000

CMD ["fava"]
