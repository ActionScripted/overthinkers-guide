# Recipes: Default
.DEFAULT_GOAL := help

# Recipe phony targets (that aren't files...all of them)
.PHONY : help $\
	start

# Recipes: Aliases
start: up
stop: down

# Recipes: Targets
down: ## Stop local services
	docker compose down
shell: ## Run shell in Hugo container
	docker compose run --entrypoint="" --rm hugo sh
up: ## Run services locally
	docker compose up

help: ## Show help
	@echo "Usage: make [recipe]\n\nRecipes:"
	@grep -h '##' $(MAKEFILE_LIST) | grep -v grep | sed -e 's/\(.*\):.*## \(.*\)/\1|    \2/' | tr '|' '\n'
