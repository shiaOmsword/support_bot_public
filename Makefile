.PHONY: up down restart build logs shell ps pull deploy
SERVICE=WEB
# Поднять контейнеры
up:
	docker compose up -d

# Остановить контейнеры
down:
	docker compose down

# Перезапуск
restart: down up

# Пересобрать контейнеры
build:
	docker compose up -d --build

# Логи
logs:
	docker compose logs -f $(SERVICE) --tail=100

# Список контейнеров
ps:
	docker compose ps

# Зайти в контейнер (web по умолчанию)
shell:
	docker compose exec $(SERVICE) sh

# Обновить код
pull:
	git pull

# Полный деплой
deploy:
	pull build

DB_SERVICE=db
DB_USER=postgres
DB_NAME=support_bot
db-users:
	docker compose exec $(DB_SERVICE) psql -U $(DB_USER) -d $(DB_NAME) -x -c "SELECT * FROM user_state ORDER BY last_seen_at DESC LIMIT 100;"
