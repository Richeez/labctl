PROJECT=labctl

PREFIX=/opt/labctl

install:
	sudo ./install.sh

uninstall:
	sudo ./uninstall.sh

lint:
	shellcheck $$(find . -name "*.sh")

format:
	shfmt -w .

test:
	./tests/run_tests.sh

coverage:
	kcov coverage ./tests/run_tests.sh

clean:
	rm -rf coverage
	rm -rf cache

help:
	@echo "make install"
	@echo "make uninstall"
	@echo "make test"
	@echo "make coverage"
	@echo "make lint"
	@echo "make format"