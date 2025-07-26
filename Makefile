# POSIX Shell Utilities Makefile

PREFIX = $(HOME)/.local
BINDIR = $(PREFIX)/bin
SHAREDIR = $(PREFIX)/share
UTILS = $(notdir $(wildcard utils/*))

.PHONY: all build install uninstall test clean help

all: build

build:
	@echo "Building utilities..."
	@[ -n "$(UTILS)" ] || (echo "Error: No utilities found in utils/" && exit 1)

install: build
	@echo "Installing utilities to $(SHAREDIR)..."
	@mkdir -p $(SHAREDIR)
	@mkdir -p $(BINDIR)
	@for util in $(UTILS); do \
		echo "Installed $$util"; \
		cp -r utils/$$util $(SHAREDIR)/; \
		ln -sf $(SHAREDIR)/$$util/$$util $(BINDIR)/$$util; \
	done

uninstall:
	@echo "Uninstalling utilities..."
	@for util in $(UTILS); do \
		rm -f $(BINDIR)/$$util; \
		rm -rf $(SHAREDIR)/$$util; \
		echo "Uninstalled $$util"; \
	done

test:
	@echo "Running tests..."
	@if [ -f "utils/hush/test.sh" ]; then \
		echo "Testing hush..."; \
		cd utils/hush && /bin/sh test.sh; \
	fi
	@if [ -f "utils/logz/test.sh" ]; then \
		echo "Testing logz..."; \
		cd utils/logz && /bin/sh test.sh; \
	fi

clean:
	@echo "Cleaning build artifacts..."
	@rm -f *.tmp *.log

help:
	@echo "Available targets:"
	@echo "  build      - Build utilities"
	@echo "  install    - Install to ~/.local/share"
	@echo "  uninstall  - Remove installed utilities"
	@echo "  test       - Run tests"
	@echo "  clean      - Clean build artifacts"
	@echo "  help       - Show this help" 