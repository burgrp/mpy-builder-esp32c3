.DEFAULT_GOAL := help
.PHONY: dev code build flash help

IMAGE_NAME=__IMAGE_NAME__
CONTAINER_NAME=esp-idf

help:
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

flash: ## Flashes the target using "idf flash"
	./idf flash

