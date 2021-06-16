SHELL    = bash
WORK_DIR  = workdir
DNA_DIR  = $(WORK_DIR)/dna
HAPP_DIR  = $(WORK_DIR)/happ
DNA      = $(DNA_DIR)/demo-dna.dna
HAPP     = $(HAPP_DIR)/demo-happ.happ
WASM     = target/wasm32-unknown-unknown/release/wikinodes.wasm

# External targets; Uses a nix-shell environment to obtain Holochain runtimes, run tests, etc.
.PHONY: all FORCE
all: nix-test

# eg:
# 	make nix-test
# 	make nix-build
#   ...
nix-%:
	nix-shell --pure --run "make $*"

# Internal targets; require a Nix environment in order to be deterministic.
# - Uses the version of `hc`, `holochain` on the system PATH.
# - Normally called from within a Nix environment, eg. run `nix-shell`
.PHONY:		rebuild build
rebuild:	clean build

build: $(DNA)

# Package the DNA from the built target release WASM
$(DNA):		$(WASM) FORCE
	@echo "Packaging DNA:"
	@hc dna pack $(DNA_DIR) -o $(DNA)
	@hc app pack $(HAPP_DIR) -o $(HAPP)
	@ls -l $@

# Recompile the target release WASM
$(WASM): FORCE
	@echo "Building  DNA WASM:"
	@RUST_BACKTRACE=1 CARGO_TARGET_DIR=target cargo build \
		--release --target wasm32-unknown-unknown

.PHONY: test

test: build
	cd tests && npm install && npm test

test-ci: build
	cd tests && npm ci && npm test

test-fast: build
	cd tests && ( [ -d node_modules ] || npm install ) && npm test

clippy: build
	cargo clippy --all-targets --all-features -- -D warnings

.PHONY: clean
clean:
	rm -rf \
		tests/node_modules \
		.cargo \
		target \
		$(DNA)
