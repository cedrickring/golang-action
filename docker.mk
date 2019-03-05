IMAGE_NAME?=golang-action
GITHUB_REPO=$(shell git remote get-url origin | sed 's/.*\/\(.*\)\/\(.*\)\.git/\1\/\2/')
DOCKER_REPO=$(shell echo $(GITHUB_REPO) | sed 's/\(.*\)\/\(.*\)/\1/')
ROOT_DIR?=$(CURDIR)
GO_VERSION_DIRS=$(wildcard go*)
GO_VERSIONS=$(shell echo $(GO_VERSION_DIRS) | sed 's/go//g')
ACTION_VERSION=$(shell cat Dockerfile | grep "LABEL version" | sed 's/LABEL version\="\(.*\)"/\1/')
ACTION_MAJOR_VERSION=$(shell build/semver get major $(ACTION_VERSION) )
ACTION_MINOR_VERSION=$(shell build/semver get minor $(ACTION_VERSION))

.PHONY: docker-lint
docker-lint: update-docker-go-versions ## Run Dockerfile Lint on all dockerfiles.
	dockerfile_lint -r $(ROOT_DIR)/.dockerfile_lint/github_actions.yaml $(wildcard Dockerfile* */Dockerfile*)

.PHONY: docker-build
docker-build: update-docker-go-versions ## Build the top level Dockerfile using the directory or $IMAGE_NAME as the name.
## Build the main action
	docker build $(DOCKER_BUILD_ARG) -t $(IMAGE_NAME) -t $(IMAGE_NAME):latest .
## Build specific golang versions
	for version in $(GO_VERSIONS) ; do \
		docker build $(DOCKER_BUILD_ARG) -t $(IMAGE_NAME) -t $(IMAGE_NAME):$$version go$$version/; \
	done
	
.PHONY: docker-tag
docker-tag: ## Tag the docker image using the tag script.
	docker tag $(IMAGE_NAME):latest $(DOCKER_REPO)/$(IMAGE_NAME):$(ACTION_VERSION)
	docker tag $(IMAGE_NAME):latest $(DOCKER_REPO)/$(IMAGE_NAME):$(ACTION_MAJOR_VERSION)
	docker tag $(IMAGE_NAME):latest $(DOCKER_REPO)/$(IMAGE_NAME):$(ACTION_MAJOR_VERSION).$(ACTION_MINOR_VERSION)
	for version in $(GO_VERSIONS) ; do \
		docker tag $(IMAGE_NAME):$$version $(DOCKER_REPO)/$(IMAGE_NAME):$(ACTION_VERSION)-go$$version; \
		docker tag $(IMAGE_NAME):$$version $(DOCKER_REPO)/$(IMAGE_NAME):$(ACTION_MAJOR_VERSION)-go$$version; \
		docker tag $(IMAGE_NAME):$$version $(DOCKER_REPO)/$(IMAGE_NAME):$(ACTION_MAJOR_VERSION).$(ACTION_MINOR_VERSION)-go$$version; \
	done

.PHONY: docker-publish
docker-publish: docker-tag ## Publish the image and tags to a repository.
	docker push $(DOCKER_REPO)/$(IMAGE_NAME)
	
.PHONY: update-docker-go-versions
update-docker-go-versions: ## Updates go go1.10, go1.11 from the main Dockerfile
	for version in $(GO_VERSIONS) ; do \
		sed -e 's/FROM golang:.*/FROM golang:'$$version'/' Dockerfile > go$$version/Dockerfile; \
		cp entrypoint.sh  go$$version/; \
	done

update-version = sed -i.bak -e 's/LABEL version=".*"/LABEL version="'`build/semver bump $(1) $(ACTION_VERSION)`'"/' Dockerfile && rm Dockerfile.bak

.PHONY: version-bump-major
version-bump-major: docker-lint
	$(call update-version,major)
	$(MAKE) -C . update-docker-go-versions
	
.PHONY: version-bump-minor
version-bump-minor: docker-lint
	$(call update-version,minor)
	$(MAKE) -C . update-docker-go-versions

.PHONY: version-bump-patch
version-bump-patch: docker-lint
	$(call update-version,patch)
	$(MAKE) -C . update-docker-go-versions
