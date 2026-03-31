#!/usr/bin/env bash
set -euo pipefail

DB_CONTAINER="db"
BOT_CONTAINER="bot"
DB_USER="postgres"
DB_NAME="support_bot"
MAX_RETRIES=30

echo "===> Жду готовности Postgres..."
for i in $(seq 1 $MAX_RETRIES); do
  if docker compose exec -T "$DB_CONTAINER" pg_isready -U "$DB_USER" >/dev/null 2>&1; then
    echo "===> Postgres готов."
    break
  fi

  if [ "$i" -eq "$MAX_RETRIES" ]; then
    echo "ERROR: Postgres не стал доступен."
    exit 1
  fi

  sleep 2
done

echo "===> Проверяю базу ${DB_NAME}..."
DB_EXISTS=$(docker compose exec -T "$DB_CONTAINER" psql -U "$DB_USER" -tAc "SELECT 1 FROM pg_database WHERE datname='${DB_NAME}';" | tr -d '[:space:]')

if [ "$DB_EXISTS" != "1" ]; then
  echo "===> Создаю базу ${DB_NAME}..."
  docker compose exec -T "$DB_CONTAINER" psql -U "$DB_USER" -c "CREATE DATABASE ${DB_NAME};"
else
  echo "===> База уже существует."
fi

echo "===> Применяю миграции..."
docker compose exec -T "$BOT_CONTAINER" alembic upgrade head

echo "===> Перезапускаю бота..."
docker compose restart "$BOT_CONTAINER"

echo "===> Последние логи бота:"
docker compose logs --tail=50 "$BOT_CONTAINER"

echo "===> Восстановление завершено."
