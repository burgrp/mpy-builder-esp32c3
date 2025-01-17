# This file is to be included to the Makefile of the project which uses the builder container.
# Expected variables are:
# - PROJECT_NAME - name of the project
# - PORT - serial port to be used for flashing and repl

.DEFAULT_GOAL := help
.PHONY: help submodule start port vanilla freeze flash dev

include $(dir $(lastword $(MAKEFILE_LIST)))/versions.inc

BUILDER_IMAGE=ghcr.io/burgrp/mpy-builder-esp32c3:${MPY_VERSION}-${IDF_VERSION}

CONTAINER_NAME=${PROJECT_NAME}-builder

ifeq ($(wildcard /project),)
	RUN?=podman exec -it ${CONTAINER_NAME}
else
	RUN=cd /opt/mpy/ports/esp32;
endif

help:
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

submodule: ## Initializes and updates git submodules
	git submodule init
	git submodule update

start:	## Starts build container
	podman run -it --rm --name ${CONTAINER_NAME} --privileged -v ${PWD}:/project -v /dev:/dev -w /opt/mpy/ports/esp32 -e BOARD=ESP32_GENERIC_C3 ${BUILDER_IMAGE}

port: ## Checks if PORT is set
	@[ "${PORT}" ] || ( echo ">> PORT is not set"; exit 1 )

clean: ## Cleans the build directory
	${RUN} make clean

vanilla: clean ## Builds vanilla MicroPython for further development using `make dev`
	${RUN} make FROZEN_MANIFEST=/project/manifest-dev.py USER_C_MODULES=/project/modules.cmake

dev: port ## Mount application directory, run main and repl
	${RUN} mpremote connect ${PORT} mount -l /project/app exec "import main" repl

frozen: clean ## Builds frozen application
	${RUN} make FROZEN_MANIFEST=/project/manifest.py USER_C_MODULES=/project/modules.cmake

flash: port ## Flashes the application - requires the project to by already built using `make vanilla` or `make freeze`
	${RUN} make PORT=${PORT} deploy
