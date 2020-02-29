NAME = idfyed/gke-nginx
VERSION = 1.0.0-alpine

.PHONY: all build test tag_latest release ssh

all: build

build:
	docker build -t $(NAME):$(VERSION) -t $(NAME) --rm image

test:
	./testrunner.sh

release: test
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! head -n 1 Changelog.md | grep -q $(VERSION); then echo 'Please note the release in Changelog.md.' && false; fi
	git push
	git tag $(VERSION)
	git push origin $(VERSION)
