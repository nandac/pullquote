# ==============================================================================
# Configuration & Variables
# ==============================================================================

# Distribution Extension Folder Path
EXT_DIR := _extensions/pullquote

# Location of the core filter engine inside the extension
FILTER_DIST := $(EXT_DIR)/pullquote.lua

# Root-level filter shortcut for Pandoc/Quarto execution
FILTER_FILE := pullquote.lua

# Core distribution CSS file (hand-authored; not generated)
CSS_FILE := $(EXT_DIR)/pullquote.css

# Demonstration Document Name (Change this to rename your showcase file)
DEMO_NAME := pullquote-examples
DEMO_SRC  := test/$(DEMO_NAME).md

# Allow to use a different pandoc binary, e.g. when testing.
PANDOC ?= pandoc
# Allow to adjust the diff command if necessary
DIFF = diff

# Current version, i.e., the latest tag. Used to version the quarto extension.
VERSION = $(shell git tag --sort=-version:refname --merged | head -n1 | \
                         sed -e 's/^v//' | tr -d "\n")
ifeq "$(VERSION)" ""
VERSION = 0.0.0
endif

# Default behavior when running `make` with no target
.DEFAULT_GOAL := help

# ==============================================================================
# Dynamic Test Detection (Driven directly by fixture files)
# ==============================================================================
TEST_MDS   := $(wildcard test/fixtures/*.md)
ALL_TEST_NAMES := $(patsubst test/fixtures/%.md,%,$(TEST_MDS))

# Filter out the error-testing file so it isn't passed to the AST diff or preview generators
TEST_NAMES := $(filter-out test-errors, $(ALL_TEST_NAMES))
DIFF_NAMES := $(TEST_NAMES)

# Reusable Defaults Chaining Profiles
DEFAULTS_SHARED := --defaults=test/settings/shared.yaml
DEFAULTS_LATEX  := $(DEFAULTS_SHARED) --defaults=test/settings/latex.yaml
DEFAULTS_TYPST  := $(DEFAULTS_SHARED) --defaults=test/settings/typst.yaml
DEFAULTS_HTML   := $(DEFAULTS_SHARED) --defaults=test/settings/html.yaml


# ==============================================================================
# Help Menu (Self-Documenting Target)
# ==============================================================================
.PHONY: help
help: ## Show this help menu
	@echo "Pandoc Pullquote Extension Build System"
	@echo "==============================================="
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)


# ==============================================================================
# Master Pipeline
# ==============================================================================
.PHONY: all
all: clean filter-proxy docs previews test ## Run the complete clean, build, test, and docs pipeline


# ==============================================================================
# Environment Setup (Cross-Platform Root-level Filter Proxy)
# ==============================================================================
$(FILTER_FILE): $(FILTER_DIST)
	@echo "--- Auto-generated proxy for cross-platform compatibility" > $@
	@echo "return dofile('$(FILTER_DIST)')" >> $@

.PHONY: filter-proxy
filter-proxy: $(FILTER_FILE) ## Generate the cross-platform root-level filter proxy


# ==============================================================================
# Testing Rules (Using clean YAML Defaults + Format Overrides)
# ==============================================================================
.PHONY: test
test: $(FILTER_FILE) $(addprefix test-,$(DIFF_NAMES)) test-errors ## Run all multi-backend AST differential tests and error tests

test-%: $(FILTER_FILE) test/fixtures/%.md
	@echo "🧪 Verifying AST layout integrity for case: $*"
	@# 1. Validate LaTeX output pathway (Skip if test fixture is Typst-specific)
	@case "$*" in \
		*typst) echo "  ⏩ Skipping LaTeX pathway for Typst-specific fixture" ;; \
		*) $(PANDOC) test/fixtures/$*.md $(DEFAULTS_LATEX) -t json | $(PANDOC) -f json -t native | $(DIFF) test/expected/latex/expected-$*.native - ;; \
	esac
	@# 2. Validate Typst output pathway (Skip if test fixture is LaTeX-specific)
	@case "$*" in \
		*latex) echo "  ⏩ Skipping Typst pathway for LaTeX-specific fixture" ;; \
		*) if [ -f test/expected/typst/expected-$*.native ]; then \
			$(PANDOC) test/fixtures/$*.md $(DEFAULTS_TYPST) -t json | $(PANDOC) -f json -t native | $(DIFF) test/expected/typst/expected-$*.native -; \
		fi ;; \
	esac
	@# 3. Validate HTML output pathway (Unconditionally evaluated for both profiles)
	@if [ -f test/expected/html/expected-$*.native ]; then \
		$(PANDOC) test/fixtures/$*.md $(DEFAULTS_HTML) -t json | \
			$(PANDOC) -f json -t native | $(DIFF) test/expected/html/expected-$*.native -; \
	fi

.PHONY: update-expected
update-expected: $(FILTER_FILE) $(addprefix update-,$(DIFF_NAMES)) ## Regenerate all target ground-truth AST snapshots

update-%: $(FILTER_FILE) test/fixtures/%.md
	@mkdir -p test/expected/html test/expected/latex test/expected/typst
	@case "$*" in \
		*typst) rm -f test/expected/latex/expected-$*.native ;; \
		*) $(PANDOC) test/fixtures/$*.md $(DEFAULTS_LATEX) -t json | $(PANDOC) -f json -t native > test/expected/latex/expected-$*.native ;; \
	esac
	@case "$*" in \
		*latex) rm -f test/expected/typst/expected-$*.native ;; \
		*) $(PANDOC) test/fixtures/$*.md $(DEFAULTS_TYPST) -t json | $(PANDOC) -f json -t native > test/expected/typst/expected-$*.native ;; \
	esac
	$(PANDOC) test/fixtures/$*.md $(DEFAULTS_HTML) -t json | $(PANDOC) -f json -t native > test/expected/html/expected-$*.native

.PHONY: test-errors
test-errors: $(FILTER_FILE) test/fixtures/test-errors.md ## Test expected failure states and warnings
	@echo "🧪 Verifying error handling and graceful failures..."
	@echo "  Checking fatal error (Invalid Colors)..."
	@if $(PANDOC) test/fixtures/test-errors.md --lua-filter=$(FILTER_FILE) $(DEFAULTS_HTML) -t html > /dev/null 2> error_log.txt; then \
		echo "  ❌ FAIL: Pandoc should have crashed on an invalid color, but it succeeded."; \
		rm error_log.txt; exit 1; \
	else \
		if grep -q "CRITICAL ERROR: Undefined color keyword" error_log.txt; then \
			echo "  ✅ PASS: Caught expected fatal error."; \
		else \
			echo "  ❌ FAIL: Pandoc crashed, but not for the expected reason."; \
			cat error_log.txt; rm error_log.txt; exit 1; \
		fi \
	fi
	@echo "  Checking warnings (Invalid Taxonomy Keys)..."
	@if grep -q "Invalid value .* for pq-size" error_log.txt && \
	    grep -q "Unknown text-align value" error_log.txt && \
	    grep -q "Unknown box-align value" error_log.txt; then \
		echo "  ✅ PASS: Caught all taxonomy fallback warnings."; \
	else \
		echo "  ❌ FAIL: Expected taxonomy warnings not found."; \
		cat error_log.txt; rm error_log.txt; exit 1; \
	fi
	@echo "  Checking warnings (Missing fenced_divs extension)..."
	@$(PANDOC) test/fixtures/test-errors.md --lua-filter=$(FILTER_FILE) -f markdown-fenced_divs -t html > /dev/null 2> error_log.txt || true
	@if grep -q "Required extension \"fenced_divs\" is disabled" error_log.txt; then \
		echo "  ✅ PASS: Caught missing extension warning."; \
	else \
		echo "  ❌ FAIL: Expected fenced_divs warning not found."; \
		cat error_log.txt; rm error_log.txt; exit 1; \
	fi
	@rm -f error_log.txt

# ==============================================================================
# Visual Previews Generation (Segmented Target Directories Layout)
# ==============================================================================
PREVIEWS_DIR := artifacts
SYNTAX_HIGHLIGHTING := zenburn

PREVIEW_HTMLS      := $(patsubst %,$(PREVIEWS_DIR)/html/html-%.html,$(TEST_NAMES))
PREVIEW_LATEX_PDFS := $(patsubst %,$(PREVIEWS_DIR)/latex/latex-%.pdf,$(filter-out %typst,$(TEST_NAMES)))
PREVIEW_TYPST_PDFS := $(patsubst %,$(PREVIEWS_DIR)/typst/typst-%.pdf,$(filter-out %latex,$(TEST_NAMES)))

.PHONY: previews
previews: $(FILTER_FILE) $(PREVIEW_HTMLS) $(PREVIEW_TYPST_PDFS) $(PREVIEW_LATEX_PDFS) ## Build visual layout panels mapped across isolated target directories

$(PREVIEWS_DIR)/html/html-%.html: test/fixtures/%.md
	@mkdir -p $(@D)
	@cp test/assets/preview-styles.css $(@D)/ 2>/dev/null || true
	$(PANDOC) $< \
		$(DEFAULTS_HTML) \
		--syntax-highlighting=$(SYNTAX_HIGHLIGHTING) \
		--number-sections \
		--shift-heading-level-by=-1 \
		--output=$@

$(PREVIEWS_DIR)/typst/typst-%.pdf: test/fixtures/%.md
	@mkdir -p $(@D)
	$(PANDOC) $< \
		$(DEFAULTS_TYPST) \
		--syntax-highlighting=$(SYNTAX_HIGHLIGHTING) \
		--number-sections \
		--shift-heading-level-by=-1 \
		--to=pdf \
		--output=$@

$(PREVIEWS_DIR)/latex/latex-%.pdf: test/fixtures/%.md
	@mkdir -p $(@D)
	$(PANDOC) $< \
		$(DEFAULTS_LATEX) \
		--syntax-highlighting=$(SYNTAX_HIGHLIGHTING) \
		--number-sections \
		--shift-heading-level-by=-1 \
		--to=pdf \
		--output=$@


# ==============================================================================
# Documentation System (With Dual-Engine Output Targets)
# ==============================================================================
.PHONY: docs
docs: docs/index.html docs/$(DEMO_NAME).html docs/$(DEMO_NAME)-latex.pdf docs/$(DEMO_NAME)-typst.pdf docs/pullquote.lua ## Build the standalone docs portal with dual-format PDFs

docs/index.html: README.md $(DEMO_SRC) $(FILTER_FILE) .tools/docs.lua docs/$(DEMO_NAME)-output.md docs/style.css
	@mkdir -p docs
	$(PANDOC) \
		--standalone \
		--lua-filter=.tools/docs.lua \
		--metadata=sample-file:$(DEMO_SRC) \
		--metadata=result-file:docs/$(DEMO_NAME)-output.md \
		--metadata=code-file:$(FILTER_FILE) \
		--css=style.css \
		--toc \
		--output=$@ $<

docs/style.css:
	curl --silent --show-error --output $@ \
		'https://cdn.jsdelivr.net/gh/kognise/water.css@latest/dist/light.css'

docs/$(DEMO_NAME)-output.md: $(FILTER_FILE) $(DEMO_SRC)
	$(PANDOC) \
		--output=$@ \
		--lua-filter=$(FILTER_FILE) \
		--to=markdown \
		--standalone \
		$(DEMO_SRC)

docs/$(DEMO_NAME).html: $(DEMO_SRC)
	@mkdir -p $(@D)
	@cp test/assets/preview-styles.css $(@D)/ 2>/dev/null || true
	$(PANDOC) $< \
		$(DEFAULTS_HTML) \
		--syntax-highlighting=$(SYNTAX_HIGHLIGHTING) \
		--output=$@

docs/$(DEMO_NAME)-latex.pdf: $(DEMO_SRC)
	$(PANDOC) $< \
		$(DEFAULTS_LATEX) \
		--syntax-highlighting=$(SYNTAX_HIGHLIGHTING) \
		--to=pdf \
		--output=$@

docs/$(DEMO_NAME)-typst.pdf: $(DEMO_SRC)
	$(PANDOC) $< \
		$(DEFAULTS_TYPST) \
		--syntax-highlighting=$(SYNTAX_HIGHLIGHTING) \
		--to=pdf \
		--pdf-engine-opt=--root=. \
		--output=$@

docs/pullquote.lua: $(FILTER_FILE)
	@mkdir -p docs
	cp $(FILTER_FILE) $@


# ==============================================================================
# Housekeeping
# ==============================================================================
.PHONY: clean
clean: ## Purge all temporary assets and generated distribution instances
	rm -f docs/$(DEMO_NAME)-output.md docs/index.html docs/$(DEMO_NAME).html docs/$(DEMO_NAME)-latex.pdf docs/$(DEMO_NAME)-typst.pdf docs/style.css docs/preview-styles.css docs/pullquote.lua
	rm -rf $(PREVIEWS_DIR)
	rm -f $(FILTER_FILE)
	rm -f error_log.txt
