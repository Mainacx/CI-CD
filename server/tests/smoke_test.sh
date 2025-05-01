#!/bin/bash
set -e

echo "→ Запускаем контейнеры"
docker compose up -d --build

echo "→ Ждём 15 секунд инициализации..."
sleep 15

echo "→ Проверяем HTTPS health-эндпоинт:"
if curl -kfs https://localhost:8080/healthz | grep -q "200 OK"; then
  echo "✅ Сервер работает!"
else
  echo "❌ Ошибка: сервер не ответил по HTTPS"
  docker compose logs
  exit 1
fi

echo "→ Проверяем HTTP health-эндпоинт (редирект):"
if curl -fs http://localhost:8080/healthz | grep -q "200 OK"; then
  echo "✅ Сервер отвечает и по HTTP"
else
  echo "⚠️  Сервер не отвечает по HTTP (ожидаемо для HTTPS-режима)"
fi

echo "→ Останавливаем контейнеры"
docker compose down