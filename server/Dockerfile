FROM python:3.9-slim

EXPOSE 8080

WORKDIR /app

COPY . .
RUN pip install -r server/requirements.txt --no-cache-dir


RUN mkdir -p certs && \
    if [ ! -f certs/cert.pem ]; then \
        openssl req -newkey rsa:2048 -nodes -keyout certs/key.pem -x509 -days 365 -out certs/cert.pem \
        -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=localhost"; \
    fi && \
    ls -l certs

CMD ["python", "server/app.py"]
