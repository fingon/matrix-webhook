FROM python:3.13-slim AS builder
RUN pip install --no-cache-dir --break-system-packages markdown matrix-nio

FROM gcr.io/distroless/python3-debian12:nonroot
COPY --from=builder /usr/local/lib/python3.13/site-packages /usr/local/lib/python3.13/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin
COPY matrix_webhook matrix_webhook/
EXPOSE 4785
ENTRYPOINT ["python", "-m", "matrix_webhook"]
