# Pumpkin - Top-level build orchestration
# Builds all subprojects and coordinates testing

.PHONY: all build clean test
.PHONY: build-tokenizer build-indexer
.PHONY: clean-tokenizer clean-indexer
.PHONY: test-tokenizer test-indexer

# === Main Targets ===

# Build all subprojects
all: build

build: build-tokenizer build-indexer build-parser

clean: clean-tokenizer clean-indexer clean-parser

test: test-tokenizer test-indexer test-parser

# === Tokenizer (OCaml) ===

build-tokenizer:
	@echo "==> Building tokenizer (OCaml)..."
	cd tokenizer && dune build

clean-tokenizer:
	@echo "==> Cleaning tokenizer..."
	cd tokenizer && dune clean

test-tokenizer:
	@echo "==> Testing tokenizer..."
	cd tokenizer && dune test

# === Indexer (Go) ===

build-indexer:
	@echo "==> Building indexer (Go)..."
	cd indexer && $(MAKE) build

clean-indexer:
	@echo "==> Cleaning indexer..."
	cd indexer && $(MAKE) clean

test-indexer:
	@echo "==> Testing indexer..."
	cd indexer && $(MAKE) test


# === Parser (OCaml) ===

build-parser:
	@echo "==> Building parser (OCaml)..."
	cd parser && dune build

clean-parser:
	@echo "==> Cleaning parser..."
	cd parser && dune clean

test-parser:
	@echo "==> Testing parser..."
	cd parser && dune test
