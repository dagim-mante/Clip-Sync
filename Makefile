-include .env
export

.PHONY: server/run \
        server/compose-up server/compose-down server/compose-ps \
        server/compose-logs server/compose-psql \
        server/migrate-create server/migrate-up server/migrate-down

# Run Server
server/run:
	cd server && air

# Docker compose related
COMPOSE = docker compose --env-file .env -f server/docker-compose.yml
server/compose-up:
	$(COMPOSE) up -d

server/compose-down:
	$(COMPOSE) down

server/compose-ps:
	$(COMPOSE) ps

server/compose-logs:
	$(COMPOSE) logs -f db

server/compose-psql:
	$(COMPOSE) exec db psql -U $(POSTGRES_USER) -d $(POSTGRES_DB)


# Goose migrations related
server/migrate-create:
	$(if $(name),,$(error usage: make server/migrate-create name=create_users_table))
	goose create $(name) sql

server/migrate-up:
	goose up

server/migrate-down:
	goose down