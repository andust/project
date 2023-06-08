include .site-service.env

GO_WORKSPACE=go-workspace

SITE_SERVICE=site-service
SITE_BINARY=siteApp

init:
	docker run --rm -v $(PWD)/../$(SITE_SERVICE)/:/app/$(SITE_SERVICE) -w /app/$(SITE_SERVICE) golang:1.20-alpine sh -c "go build -o $(SITE_BINARY) ./cmd/service"

up:
	@echo "Starting docker images..."
	docker-compose up -d
	@echo "Docker images started!"

down:
	@echo "Stopping docker compose..."
	docker-compose down
	@echo "Done!"

build-site-service:
	docker-compose exec --workdir /app/$(SITE_SERVICE) -it $(GO_WORKSPACE) env GOOS=linux CGO_ENABLED=0 go build -o $(SITE_BINARY) ./cmd/service

restart-site-service: build-site-service
	docker-compose up --build -d $(SITE_SERVICE)
