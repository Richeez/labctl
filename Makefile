###############################################################################
# LABCTL Makefile
###############################################################################

.DEFAULT_GOAL := help

.PHONY: help install uninstall reinstall update doctor test clean version

help:
	@echo
	@echo "LABCTL Developer Commands"
	@echo
	@echo "Available Targets:"
	@echo "  install     Install LABCTL"
	@echo "  uninstall   Remove LABCTL"
	@echo "  purge  Parmanently remove LABCTL"
	@echo "  update      Update existing installation"
	@echo "  doctor      Run LABCTL diagnostics"
	@echo "  version     Show version"
	@echo "  test        Run tests"
	@echo "  test        Run tests"
	@echo "  clean       Remove temporary files"
	@echo

install:
	@sudo ./bin/labctl install

uninstall:
	@sudo ./bin/labctl uninstall

update:
	@sudo ./bin/labctl update

purge:
	@sudo ./bin/labctl uninstall --purge	

doctor:
	@labctl doctor

version:
	@labctl version

test:
	@bash tests/run.sh

clean:
	@find . -type f \( -name "*.tmp" -o -name "*.bak" -o -name "*.cache" \) -delete
