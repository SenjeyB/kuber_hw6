# ДЗ 6 от Полтанова СИ

## Запуск

```bash
./start.sh
```

`start.sh` автоматически запускает port-forward. URLs:

| Компонент | URL | Логин |
|-----------|-----|-------|
| Grafana | http://localhost:3000 | admin / admin |
| Zipkin | http://localhost:9411 | - |
| muffin-wallet | http://localhost:8080/swagger-ui/index.html | - |

## Просмотр логов

1. Открыть http://localhost:3000
2. Explore → выбрать **Loki**
3. Ввести запрос: `{pod=~"muffin-wallet.*"}`
4. Нажать **Run query**

## Просмотр трейсов

1. Открыть http://localhost:9411
2. Выбрать **serviceName**: `muffin`
3. Нажать **Run Query**
4. Кликнуть на трейс для просмотра spans

## Тестирование

```bash
./load.sh    # генерация нагрузки
```
