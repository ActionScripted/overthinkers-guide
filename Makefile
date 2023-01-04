# Load dotenv
ifneq (,$(wildcard ./.env))
	include .env
	export
endif


# Args/vars
docker_bin_path := "/Applications/Docker.app/Contents/Resources/bin"


# Recipes: Default
.DEFAULT_GOAL := help

# Recipe phony targets (that aren't files...all of them)
.PHONY : help $\
	_wait-for-docker $\
	build $\
	clean $\
	dev $\
	develop $\
	down $\
	help $\
	setup $\
	shell $\
	start $\
	stop $\
	up

# Recipes: Aliases
dev: up
develop: up
start: up
stop: down

# Recipes: Internal
_wait-for-docker:
	@echo Checking/waiting for Docker Desktop...
	@while ! "${docker_bin_path}"/docker info &>/dev/null; do sleep 1; done

# Recipes: Targets
down: ## Stop local services
	@docker compose down
clean: ## Cleanup local, non-critical shenanigans
	@rm -rf public
	@rm -rf resources/_gen
build: ## Build site locally
	docker compose run --entrypoint="" --rm hugo hugo ${HUGO_ARGS_SHARED}
help: ## Show help
	@echo "Usage: make [recipe]\n\nRecipes:"
	@grep -h '##' $(MAKEFILE_LIST) | grep -v grep | sed -e 's/\(.*\):.*## \(.*\)/\1|    \2/' | tr '|' '\n'
shell: _wait-for-docker ## Run shell in Hugo container
	@docker compose run --entrypoint="" --rm hugo bash
setup: ## Setup local environment
	@cp .env.example .env
	@pre-commit install
npm: ## TODO wtf man, clean this up
	@docker compose run --entrypoint="" --rm hugo bash -c \
		"cd ./overthinkers-guide/themes/brain; cp package.json package.hugo.json"
	@docker compose run --entrypoint="" --rm hugo \
		hugo mod npm pack --source=./overthinkers-guide
	@docker compose run --entrypoint="" --rm hugo bash -c \
		"pushd ./overthinkers-guide && npm install && popd"
	@chmod 644 ./overthinkers-guide/themes/brain/package*.json
	@chmod 644 ./overthinkers-guide/package*.json
up: _wait-for-docker ## Run services locally
	@sleep 2 && open "http://localhost:1313" & docker compose up
