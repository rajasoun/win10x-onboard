APP_NAME="pester-runner"
# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# DOCKER TASKS
# Build the container
build: ## Build the container
	docker build -t $(APP_NAME) pester-runner

shell: ## Shell to container 
	docker run --rm -it --name="$(APP_NAME)" -v "${PWD}:/test" --entrypoint=pwsh $(APP_NAME)

run: ## Run container 
	docker run --rm --name="$(APP_NAME)" -v "${PWD}:/test" $(APP_NAME)


