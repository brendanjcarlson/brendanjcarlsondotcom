.PHONY: build
build:
	@./shell/build.sh

.PHONY: run
run: build
	@./bin/web
