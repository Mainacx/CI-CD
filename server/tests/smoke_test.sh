#!/bin/bash

# Запускаем сервер в фоне
docker-compose up -d --build
sleep 5  # Ждём инициализации

# Проверяем health-эндпоинт
if curl -fs http://localhost:8080/healthz | grep -q "200 OK"; then
  echo "✅ Сервер работает!"
else
  echo "❌ Ошибка: сервер не ответил"
  docker-compose logs  # Показываем логи при ошибке
  exit 1
fi

# Останавливаем контейнеры
docker-compose down