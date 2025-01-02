# Docker-related variables
DOCKER_COMPOSE = docker compose
SERVICE_NAME = dr_quine

all: build up exec

# Targets
build:
	@echo "Building the Docker image..."
	@$(DOCKER_COMPOSE) build

up:
	@echo "Starting the Docker container..."
	@$(DOCKER_COMPOSE) up -d

down:
	@echo "Stopping the Docker container..."
	@$(DOCKER_COMPOSE) down

exec:
	@echo "Accessing the Docker container..."
	@$(DOCKER_COMPOSE) exec -it $(SERVICE_NAME) bash

logs:
	@echo "Showing container logs..."
	@$(DOCKER_COMPOSE) logs -f

clean:
	@echo "Cleaning up..."
	@$(DOCKER_COMPOSE) down --volumes --remove-orphans
	@docker system prune -f

.PHONY: build up down exec logs clean
