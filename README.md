### 1. Синзронизируем все зависимости проекта при помощи uv
```bash
uv sync
```
### 2. Структура проекта 
```
├── models -- Решение задач по мл
│   ├── first_task.ipynb -- 1
│   ├── second_task.ipynb -- 2
│   └── third_task.ipynb -- 3
├── sql_tasks
│   ├── task_1 -- Первая задача по sql
│   │   ├── 1_task.sql -- init script 
│   │   ├── Dockerfile
│   │   ├── docker-compose.yaml
│   │   └── main.sql -- Запрос с решением задачи
│   └── task_2 -- Вторая задача по sql
│       ├── 2_task.sql -- init script
│       ├── Dockerfile
│       ├── docker-compose.yaml
│       └── main.sql -- Запрос с решением задачи
```

### 3. Инструкция запуска задач по sql

```bash
docker compose up -d --build
```

Запуск контейнера
```bash
docker exec -it postgres_db psql -U myuser -d mydb -f /docker-entrypoint-initdb.d/main.sql
```

**Аналогично с запуском воторого решения**


### Models решения 1, 2 и 3 соответственно названия файлов
