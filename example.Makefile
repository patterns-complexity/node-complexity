# Load .env if it exists
ifneq ("$(wildcard .env)","")
	include .env
	export
endif

# Constants
COL_WHITE=\033[1;37m
COL_GREEN=\033[1;32m
COL_YELLOW=\033[1;33m
COL_RED=\033[1;31m
COL_DEF=\033[0m
DEF_ERR_MSG="$(COL_RED)\nSomething went wrong. Please, check the logs above.$(COL_DEF)"

# Targets
.PHONY: all help install build build-prod start start-prod stop restart logs clean rebuild rebuild-prod test coverage

# This is the default target, which will be executed if no target is specified
all: help

# This target will be executed if you run `make help`
help:
	@echo "$(COL_WHITE)Usage: make [$(COL_GREEN)target$(COL_WHITE)]"
	@echo ""
	@echo "$(COL_GREEN)If this is the first time you are running this project, please run$(COL_YELLOW) make install$(COL_GREEN) to install it first. $(COL_WHITE)"
	@echo ""
	@echo "Targets:"
	@echo "  install       Install the project"
	@echo "  build         Build the project"
	@echo "  build-prod    Build the project for production"
	@echo "  start         Start the project"
	@echo "  start-prod    Start the project for production"
	@echo "  rebuild	   First clean and then build the project"
	@echo "  rebuild-prod  First clean and then build the project for production"
	@echo "  stop          Stop the project"
	@echo "  restart       Restart the project"
	@echo "  logs          Show the logs"
	@echo "  clean         Clean the project"
	@echo "  help          Show this help message"

install:
	@echo "$(COL_WHITE)"
	@echo "Installing the project..."
	@echo ""
	@mkdir ./src || echo "$(COL_YELLOW)Something went wrong. Please, create the src folder manually.$(COL_WHITE)"
	@cp ./dist/example.Dockerfile ./Dockerfile || echo "$(COL_YELLOW)Something went wrong. Please, copy the ./dist/example.Dockerfile file to Dockerfile manually.$(COL_WHITE)"
	@if [ -f .env ]; then cp .env .env.backup; fi
	@cp ./dist/example.env .env || echo "$(COL_YELLOW)Something went wrong. Please, copy the ./dist/example.env file to .env manually.$(COL_WHITE)"
	@if [ -f .env.backup ]; then cat .env.backup > .env; fi
	@cp ./dist/example.entrypoint.dev.sh entrypoint.dev.sh || echo "$(COL_YELLOW)Something went wrong. Please, copy the ./dist/example.entrypoint.dev.sh file to entrypoint.dev.sh manually.$(COL_WHITE)"
	@cp ./dist/example.entrypoint.prod.sh entrypoint.prod.sh || echo "$(COL_YELLOW)Something went wrong. Please, copy the ./dist/example.entrypoint.prod.sh file to entrypoint.prod.sh manually.$(COL_WHITE)"
	@echo "$(COL_GREEN)"
	@echo "The project has been installed. Please, configure all files below to your needs:"
	@echo "  - /.env"
	@echo "  - /entrypoint.dev.sh $(COL_WHITE) (development image entrypoint) $(COL_GREEN)"
	@echo "  - /entrypoint.prod.sh $(COL_WHITE) (production image entrypoint) $(COL_GREEN)"
	@echo "  - /Dockerfile $(COL_WHITE) (Dockerfile with both a dev and a prod stage) $(COL_GREEN)"
	@echo "$(COL_WHITE)"
	@echo "After that, you can run $(COL_YELLOW)make build$(COL_WHITE) to build the project."

# This target will be executed if you run `make build`
build:
	@echo "Building the project..."
	@cp ./entrypoint.dev.sh ./src/entrypoint.sh || echo "$(COL_YELLOW)\nSomething went wrong. Please, copy the entrypoint.dev.sh file to src/entrypoint.sh manually.$(COL_WHITE)"
	@docker build -t $(IMG_NAME):$(IMG_TAG) . --target dev --build-arg UID=${UID} --build-arg GID=${GID}  && \
		echo "\n$(COL_GREEN)The project has been built. You can run $(COL_YELLOW)make start$(COL_GREEN) to start the project.$(COL_WHITE)"\
		|| echo $(DEF_ERR_MSG)

# This target will be executed if you run `make build-prod`
build-prod:
	@echo "Building the project..."
	@cp ./entrypoint.prod.sh ./src/entrypoint.sh || echo "$(COL_YELLOW)\nSomething went wrong. Please, copy the entrypoint.prod.sh file to src/entrypoint.sh manually.$(COL_WHITE)"
	@docker build -t $(IMG_NAME):$(IMG_TAG) . --target prod --build-arg UID=${UID} --build-arg GID=${GID} && \
		echo "\n$(COL_GREEN)The project has been built. You can run $(COL_YELLOW)make start-prod$(COLGREEN) to start the project.$(COL_WHITE)"\
		|| echo $(DEF_ERR_MSG)

# This target will be executed if you run `make start`
start:
	@cp ./entrypoint.dev.sh ./src/entrypoint.sh || echo "$(COL_YELLOW)\nSomething went wrong. Please, copy the entrypoint.dev.sh file to src/entrypoint.sh manually.$(COL_WHITE)"
	@chown -R $(UID):$(GID) ./src || echo "$(COL_YELLOW)\nSomething went wrong. Please, change the permissions of the src folder manually.$(COL_WHITE)"
	@chmod -R ug+rwx ./src || echo "$(COL_YELLOW)\nSomething went wrong. Please, change the permissions of the src folder manually.$(COL_WHITE)"
	@echo "$(COL_WHITE)Starting the project...$(COL_DEF)"
	@docker network create $(NET_NAME) || echo "$(COL_YELLOW)The network already exists.$(COL_DEF)"
	@docker run --network $(NET_NAME) -it -p $(PORT_OUT):$(PORT_IN) -v ./src:/app -u $(UID):$(GID) --user $(UNAME) --name $(CNT_NAME) $(IMG_NAME):$(IMG_TAG) || echo $(DEF_ERR_MSG)

# This target will be executed if you run `make start-prod`
start-prod:
	@cp ./entrypoint.prod.sh ./src/entrypoint.sh || echo "$(COL_YELLOW)\nSomething went wrong. Please, copy the entrypoint.dev.sh file to src/entrypoint.sh manually.$(COL_WHITE)"
	@echo "$(COL_WHITE)Starting the project...$(COL_DEF)"
	@docker network create $(NET_NAME) || echo "$(COL_YELLOW)The network already exists.$(COL_DEF)"
	@docker run -d --network $(NET_NAME) -p $(PORT_OUT_SSL):$(PORT_IN_SSL) --name $(CNT_NAME) $(IMG_NAME):$(IMG_TAG) || echo $(DEF_ERR_MSG)

# This target will be executed if you run `make stop`
stop:
	@echo "Stopping the project..."
	@docker stop $(CNT_NAME) || echo $(DEF_ERR_MSG)
	@docker network rm $(NET_NAME) || echo $(DEF_ERR_MSG)
	@docker container rm $(CNT_NAME) || echo $(DEF_ERR_MSG)

# This target will be executed if you run `make restart`
restart: stop start

# This target will be executed if you run `make logs`
logs:
	@docker logs $(CNT_NAME) -f || echo $(DEF_ERR_MSG)

# This target will be executed if you run `make clean`
clean:
	@echo "$(COL_WHITE)Cleaning the project..."
	@echo ""
	@docker rmi $(IMG_NAME):$(IMG_TAG)  && \
		echo "$(COL_GREEN)The project has been cleaned. You can run$(COL_YELLOW) make build$(COL_GREEN) to build the project again.$(COL_WHITE)"\
		|| echo $(DEF_ERR_MSG)

# This target will be executed if you run `make rebuild`
rebuild: clean build

# This target will be executed if you run `make rebuild-prod`
rebuild-prod: clean build-prod
