SHELL := /usr/bin/env bash

DOCKERFILE = ./Dockerfile


# Project specific values
IMAGE_REGISTRY?=quay.io
IMAGE_REPOSITORY?=jharrington22
IMAGE_NAME?=network-toolbox

COMMIT_NUMBER=$(shell git rev-list `git rev-list --parents HEAD | egrep "^[a-f0-9]{40}$$"`..HEAD --count)
CURRENT_COMMIT=$(shell git rev-parse --short=8 HEAD)

CONTAINER_VERSION=0.1.$(COMMIT_NUMBER)-$(CURRENT_COMMIT)

IMG?=$(IMAGE_REGISTRY)/$(IMAGE_REPOSITORY)/$(IMAGE_NAME):v$(CONTAINER_VERSION)
IMAGE_URI=${IMG}
IMAGE_URI_LATEST=$(IMAGE_REGISTRY)/$(IMAGE_REPOSITORY)/$(IMAGE_NAME):latest

.PHONY: docker-build
docker-build: build

.PHONY: build
build:
	docker build . -f $(DOCKERFILE) -t $(IMAGE_URI)
	docker tag $(IMAGE_URI) $(IMAGE_URI_LATEST)

.PHONY: push
push:
	docker push $(IMAGE_URI)
	docker push $(IMAGE_URI_LATEST)
