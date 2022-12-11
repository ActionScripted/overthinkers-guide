# Recipes: Default
.DEFAULT_GOAL := help

# Recipe phony targets (that aren't files...all of them)
.PHONY : help $\
	start

# Recipes: Aliases
start: up
stop: down

# Recipes: Targets
up: ## Run locally via Docker/Compose
	docker compose up

help: ## Show help
	@echo "Usage: make [recipe]\n\nRecipes:"
	@grep -h '##' $(MAKEFILE_LIST) | grep -v grep | sed -e 's/\(.*\):.*## \(.*\)/\1|    \2/' | tr '|' '\n'
