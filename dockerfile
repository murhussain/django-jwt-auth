FROM python:3.10-slim AS builder

WORKDIR /app

COPY requirements.txt .

# Retry logic for pip install
RUN set -eux; \
    for i in 1 2 3; do \
        pip install --user -r requirements.txt && break || sleep 10; \
    done

FROM python:3.10-slim

WORKDIR /app
COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH
COPY . .

EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
