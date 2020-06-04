SHELL := /usr/bin/env bash

DOCKERFILE = ./Dockerfile


# Project specific values
DOCKER_IMAGE_REGISTRY?=docker.io
QUAY_IMAGE_REGISTRY?=quay.io
IMAGE_REPOSITORY?=jharrington22
IMAGE_NAME?=network-toolbox

COMMIT_NUMBER=$(shell git rev-list `git rev-list --parents HEAD | egrep "^[a-f0-9]{40}$$"`..HEAD --count)
CURRENT_COMMIT=$(shell git rev-parse --short=8 HEAD)

CONTAINER_VERSION=0.1.$(COMMIT_NUMBER)-$(CURRENT_COMMIT)

# Quay.io image
QUAY_IMG?=$(QUAY_IMAGE_REGISTRY)/$(IMAGE_REPOSITORY)/$(IMAGE_NAME):v$(CONTAINER_VERSION)
QUAY_IMAGE_URI=${QUAY_IMG}
QUAY_IMAGE_URI_LATEST=$(QUAY_IMAGE_REGISTRY)/$(IMAGE_REPOSITORY)/$(IMAGE_NAME):latest

# Docker image
DOCKER_IMG?=$(DOCKER_IMAGE_REGISTRY)/$(IMAGE_REPOSITORY)/$(IMAGE_NAME):v$(CONTAINER_VERSION)
DOCKER_IMAGE_URI=${DOCKER_IMG}
DOCKER_IMAGE_URI_LATEST=$(DOCKER_IMAGE_REGISTRY)/$(IMAGE_REPOSITORY)/$(IMAGE_NAME):latest

.PHONY: docker-build
docker-build: build

.PHONY: build
build:
	# Build and tag images for quay.io
	docker build . -f $(DOCKERFILE) -t $(QUAY_IMAGE_URI)
	docker tag $(QUAY_IMAGE_URI) $(QUAY_IMAGE_URI_LATEST)
	# Tag docker images
	docker tag $(QUAY_IMAGE_URI) $(DOCKER_IMAGE_URI)
	docker tag $(DOCKER_IMAGE_URI) $(DOCKER_IMAGE_URI_LATEST)

.PHONY: push
push:
	# Push Quay.io images
	docker push $(QUAY_IMAGE_URI)
	docker push $(QUAY_IMAGE_URI_LATEST)
	# Push Docker images
	docker push $(DOCKER_IMAGE_URI)
	docker push $(DOCKER_IMAGE_URI_LATEST)

.PHONY: login
login:
	# Login to quay.io
	docker login -u "$$QUAY_BOT_USERNAME" --password "$$QUAY_BOT_PASSWORD" quay.io
	# Login to docker
	docker login -u "$$DOCKER_TOKEN" --password "$$DOCKER_SECRET_TOKEN"
