FROM python:3.13-slim

EXPOSE 4785

RUN pip install --no-cache-dir --break-system-packages markdown matrix-nio

ADD matrix_webhook matrix_webhook

ENTRYPOINT ["python", "-m", "matrix_webhook"]
