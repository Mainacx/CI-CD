#!/bin/bash

set -e  # Выход при первой ошибке

echo "→ Запускаем контейнеры"
docker compose up -d --build

echo "→ Ждём 10 секунд инициализации..."
sleep 10

echo "→ Проверяем health-эндпоинт:"
if curl -fs http://localhost:8080/healthz | grep -q "200 OK"; then
  echo "✅ Сервер работает!"
else
  echo "❌ Ошибка: сервер не ответил"
  docker compose logs
  exit 1
fi

echo "→ Останавливаем контейнеры"
docker compose down