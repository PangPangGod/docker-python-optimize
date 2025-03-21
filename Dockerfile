## Image 가져오는 이름 따라서 builder production 단계 다르게 사용
# ---------------- Builder Stage ---------------- #
FROM python:3.13-bookworm AS builder

RUN apt-get update && apt-get install --no-install-recommends -y \
        build-essential && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Download latest uv, install and remove installer
ADD https://astral.sh/uv/install.sh /install.sh
RUN chmod -R 655 /install.sh && /install.sh && rm /install.sh

ENV PATH="/root/.local/bin:${PATH}"

WORKDIR /app

COPY pyproject.toml uv.lock ./

RUN uv sync --no-cache

# ---------------- Production Stage ---------------- #
FROM python:3.13-slim-bookworm AS production

# RUN --mount=type=secret,id=DB_PASSWORD \
# --mount=type=secret,id=DB_USER \
# --mount=type=secret,id=DB_NAME \
# --mount=type=secret,id=DB_HOST \
# --mount=type=secret,id=ACCESS_TOKEN_SECRET_KEY \
# DB_PASSWORD=/run/secrets/DB_PASSWORD \
# DB_USER=$(cat /run/secrets/DB_USER) \
# DB_NAME=$(cat /run/secrets/DB_NAME) \
# DB_HOST=$(cat /run/secrets/DB_HOST) \
# ACCESS_TOKEN_SECRET_KEY=$(cat /run/secrets/ACCESS_TOKEN_SECRET_KEY)

# RUN --mount=type=secret,id=secret-key,target=secrets.json

RUN useradd --create-home appuser
USER appuser

WORKDIR /app

COPY app ./app
COPY --from=builder /app/.venv .venv

ENV PATH="/app/.venv/bin:$PATH"

# Expose the specified port for FastAPI
EXPOSE $PORT

# Uvicorn 실행 (app/main.py의 app 인스턴스 실행, 환경 변수 PORT 사용)
CMD ["uvicorn", "app.main:app", "--log-level", "info", "--host", "0.0.0.0", "--port", "8000"]
