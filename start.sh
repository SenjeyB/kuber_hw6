#!/bin/bash
set -e

echo "1. Запуск minikube..."
minikube start
minikube addons enable ingress

echo "2. Ожидание ingress controller..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/component=controller -n ingress-nginx --timeout=120s

echo "3. Запуск PostgreSQL..."
docker start postgres-muffin 2>/dev/null || \
docker run -d --name postgres-muffin \
  -e POSTGRES_USER=muffin-wallet -e POSTGRES_PASSWORD=muffin-wallet -e POSTGRES_DB=muffin_wallet \
  -p 5432:5432 postgres:15

echo "4. Настройка /etc/hosts..."
MINIKUBE_IP=$(minikube ip)
sudo sed -i '/muffin-wallet.local/d' /etc/hosts
echo "$MINIKUBE_IP muffin-wallet.local" | sudo tee -a /etc/hosts

echo "5. Сборка и загрузка образа muffin-wallet..."
cd muffin-wallet-src
docker build -t muffin-wallet-tracing:1.0.0 .
minikube image load muffin-wallet-tracing:1.0.0
cd ..

echo "6. Создание namespace и дашборда..."
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f manifests/grafana-dashboard-configmap.yaml

echo "7. Развёртывание через helmfile..."
helmfile sync

echo "8. Ожидание готовности подов..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=muffin-wallet-chart -n muffin --timeout=180s || true
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=grafana -n monitoring --timeout=180s || true
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=zipkin -n monitoring --timeout=180s || true
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=loki -n monitoring --timeout=180s || true

echo "9. Запуск port-forward..."
pkill -f "port-forward.*3000:3000" 2>/dev/null || true
pkill -f "port-forward.*9411:9411" 2>/dev/null || true
pkill -f "port-forward.*8080:80" 2>/dev/null || true

kubectl port-forward -n monitoring svc/grafana 3000:3000 &>/dev/null &
kubectl port-forward -n monitoring svc/zipkin 9411:9411 &>/dev/null &
kubectl port-forward -n muffin svc/muffin-wallet-muffin-wallet-chart 8080:80 &>/dev/null &

sleep 2

echo ""
echo "=== Готово ==="
echo ""
echo "Доступ:"
echo "  Grafana:       http://localhost:3000 (admin/admin)"
echo "  Zipkin:        http://localhost:9411"
echo "  muffin-wallet: http://localhost:8080/swagger-ui/index.html"
echo ""
echo "Для остановки port-forward: pkill -f 'port-forward'"

