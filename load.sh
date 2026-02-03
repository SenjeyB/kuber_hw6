#!/bin/bash

BASE_URL="${1:-http://localhost:8080}"
REQUESTS="${2:-50}"

echo "Генерация нагрузки на $BASE_URL ($REQUESTS запросов)..."

for i in $(seq 1 $REQUESTS); do
    curl -s "$BASE_URL/v1/muffin-wallets?page=0&size=10" > /dev/null &
done

wait
echo "Готово"
