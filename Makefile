CONTAINER_CMD := $(or $(CONTAINER_CMD), $(shell command -v podman 2> /dev/null))
ifndef CONTAINER_CMD
CONTAINER_CMD := docker
endif

.PHONY: install-unit-tests install-lint install clean-install unit-tests format mypy lint-manifest lint build-image full-install

install-unit-tests:
	pip install .[test-runner]
	$(MAKE) clean-install

install-lint:
	pip install .[lint]
	$(MAKE) clean-install

install:
	pip install .

full-install: install install-lint install-unit-tests

clean-install:
	rm -rf ./build

unit-tests:
	tox

format:
	black src/ tests/
	isort --profile black src tests/

mypy:
	mypy --non-interactive --install-types src/

lint-manifest:
	oc process --local=true -f openshift/template.yaml --param IMAGE_TAG=foobar --param ES_INDEX=foobar | oc apply --dry-run=client -f -

lint: mypy format
	git diff --exit-code

build-image:
	$(CONTAINER_CMD) build $(CONTAINER_BUILD_EXTRA_PARAMS) -t $(IMAGE):$(IMAGE_TAG) .

