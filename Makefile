# include .site-service.env

GO_WORKSPACE=go-workspace

GO_DOCKER=golang:1.20-alpine

SITE_SERVICE=site-service
SITE_BINARY=siteApp

init:
	docker run --rm -v $(PWD)/../$(SITE_SERVICE)/:/app/$(SITE_SERVICE) -w /app/$(SITE_SERVICE) $(GO_DOCKER) sh -c "go build -o $(SITE_BINARY) ./cmd/service"
	docker run --rm -v $(PWD)/../$(FLAT_INPUT_SERVICE)/:/app/$(FLAT_INPUT_SERVICE) -w /app/$(FLAT_INPUT_SERVICE) $(GO_DOCKER) sh -c "go build -o $(FLAT_INPUT_BINARY) ./cmd/service"

up:
	@echo "Starting docker images..."
	docker-compose up -d
	@echo "Docker images started!"

down:
	@echo "Stopping docker compose..."
	docker-compose down
	@echo "Done!"


# SITE SERVICE SERVICE COMMANDS
build-ss:
	docker-compose exec --workdir /app/$(SITE_SERVICE) -it $(GO_WORKSPACE) env GOOS=linux CGO_ENABLED=0 go build -o $(SITE_BINARY) ./cmd/service

restart-ss: build-ss
	docker-compose up --build -d $(SITE_SERVICE)

test-ss-integration:
	docker-compose exec --workdir /app/${SITE_SERVICE} -it ${GO_WORKSPACE} env CGO_ENABLED=0 go test ./... -tags=integration

test-ss:
	docker-compose exec --workdir /app/${SITE_SERVICE} -it ${GO_WORKSPACE} env CGO_ENABLED=0 go test -v -coverprofile=coverage.out ./...
	docker-compose exec --workdir /app/${SITE_SERVICE} -it ${GO_WORKSPACE} env CGO_ENABLED=0 go tool cover -html coverage.out -o coverage.html

restart: restart-ss
