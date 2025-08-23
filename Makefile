# Makefile for Next.js Frontend Application

# Variables
APP_NAME=payload
DOCKER_IMAGE_NAME=ilhamsj/$(APP_NAME)
DOCKER_TAG=latest
PLATFORM?=linux/amd64
PLATFORMS?=linux/amd64,linux/arm64
BUILDER_NAME?=multiarch

# Colors for pretty output
GREEN=\033[0;32m
NC=\033[0m # No Color

.PHONY: help build push release release-multi builder-init builder-rm

# Default target
help: ## Show this help message
	@echo "Available commands:"
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Docker
build: ## Build Docker image
	@echo "$(GREEN)Building Docker image...$(NC)"
	docker build --platform $(PLATFORM) -t $(DOCKER_IMAGE_NAME):$(DOCKER_TAG) .

push: ## Push Docker image to Docker Hub
	@echo "$(GREEN)Pushing Docker image...$(NC)"
	docker push $(DOCKER_IMAGE_NAME):$(DOCKER_TAG)

release: build push ## Build and push image to Docker Hub
	@echo "$(GREEN)Image built and pushed$(NC)"

release-multi: ## Build and push multi-arch image to Docker Hub (run 'make builder-init' once)
	@echo "$(GREEN)Building and pushing multi-arch image...$(NC)"
	docker buildx build --builder $(BUILDER_NAME) --platform $(PLATFORMS) -t $(DOCKER_IMAGE_NAME):$(DOCKER_TAG) --push .

builder-init: ## Create and bootstrap a Buildx builder for multi-arch
	@echo "$(GREEN)Creating buildx builder '$(BUILDER_NAME)'...$(NC)"
	-docker buildx create --name $(BUILDER_NAME) --driver docker-container --use
	docker buildx inspect --builder $(BUILDER_NAME) --bootstrap

builder-rm: ## Remove the Buildx builder
	@echo "Removing buildx builder '$(BUILDER_NAME)'..."
	-docker buildx rm $(BUILDER_NAME)

# run the app
run: ## Run the app
	@echo "$(GREEN)Running the app...$(NC)"
	docker run -p 3000:3000 $(DOCKER_IMAGE_NAME):$(DOCKER_TAG)

##@ Utilities

size: ## Show Docker image size
	@echo "$(GREEN)Docker image size:$(NC)"
	docker images $(DOCKER_IMAGE_NAME):$(DOCKER_TAG) --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

env-example: ## Create .env.example file
	@echo "$(GREEN)Creating .env.example...$(NC)"
	@echo "# Environment Variables" > .env.example
	@echo "NEXT_PUBLIC_API_URL=http://localhost:8000" >> .env.example
	@echo "NODE_ENV=production" >> .env.example
	@echo "PORT=3000" >> .env.example