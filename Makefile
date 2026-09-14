# ==============================================================================
# Configuration & Variables
# ==============================================================================

# Distribution Extension Folder Path
EXT_DIR := _extensions/pullquote

# Location of the core filter engine inside the extension
FILTER_DIST := $(EXT_DIR)/pullquote.lua

# Root-level filter shortcut for Pandoc/Quarto execution
FILTER_FILE := pullquote.lua

# Core distribution companion files (hand-authored; not generated)
CSS_FILE   := $(EXT_DIR)/pullquote.css
TEX_FILE   := $(EXT_DIR)/pullquote.tex
TYPST_FILE := $(EXT_DIR)/pullquote.typ

# Demonstration Document Name (Change this to rename your showcase file)
DEMO_NAME := pullquote-examples
DEMO_SRC  := test/$(DEMO_NAME).md

# Allow to use a different pandoc binary, e.g. when testing.
PANDOC ?= pandoc
# Allow to adjust the diff command if necessary
DIFF = diff

# Standalone LaTeX example (compiled directly with a LaTeX engine,
# no Pandoc/Quarto involved) demonstrating pullquote.sty
STANDALONE_SRC  := test/pullquote-standalone-example.tex
STANDALONE_NAME := pullquote-standalone-example
STY_FILE        := pullquote.sty
# fontspec-dependent features need XeLaTeX/LuaLaTeX; lualatex matches the
# engine used for the Pandoc/Quarto demo PDFs above.
LATEX ?= lualatex

# Current version, i.e., the latest tag. Used to version the quarto extension.
VERSION = $(shell git tag --sort=-version:refname --merged | head -n1 | \
                         sed -e 's/^v//' | tr -d "\n")
ifeq "$(VERSION)" ""
VERSION = 2.0.0
endif

# Build date for the demo/specimen docs, computed fresh on every build instead
# of being hand-edited in test/settings/shared.yaml.
BUILD_DATE := $(shell date +%Y-%m-%d)

# Default behavior when running `make` with no target
.DEFAULT_GOAL := help

# ==============================================================================
# Dynamic Test Detection (Driven directly by fixture files)
# ==============================================================================
TEST_MDS   := $(wildcard test/fixtures/*.md)
ALL_TEST_NAMES := $(patsubst test/fixtures/%.md,%,$(TEST_MDS))

# Filter out the error-testing files so they aren't passed to the AST diff or preview generators
TEST_NAMES := $(filter-out test-errors test-errors-font, $(ALL_TEST_NAMES))
DIFF_NAMES := $(TEST_NAMES)

# Reusable Defaults Chaining Profiles
DEFAULTS_SHARED := --defaults=test/settings/shared.yaml --metadata=date:$(BUILD_DATE)
DEFAULTS_LATEX  := $(DEFAULTS_SHARED) --defaults=test/settings/latex.yaml
DEFAULTS_TYPST  := $(DEFAULTS_SHARED) --defaults=test/settings/typst.yaml
DEFAULTS_HTML   := $(DEFAULTS_SHARED) --defaults=test/settings/html.yaml

# ==============================================================================
# Help Menu (Self-Documenting Target)
# ==============================================================================
.PHONY: help
help: ## Show this help menu
	@echo "Pandoc Pullquote Extension Build System (v2.0.0 Delegated Architecture)"
	@echo "========================================================================="
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
test: $(FILTER_FILE) $(addprefix test-,$(DIFF_NAMES)) test-errors test-font ## Run all multi-backend AST differential tests and error tests

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
test-errors: $(FILTER_FILE) test/fixtures/test-errors.md test/fixtures/test-colors.md test/fixtures/test-font-styles.md ## Test expected failure states and warnings
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
	@echo "  Checking fatal error (Invalid Colors) is symmetric across formats..."
	@for fmt_defaults_engine in "$(DEFAULTS_LATEX):latex" "$(DEFAULTS_TYPST):typst"; do \
		fmt_defaults=$${fmt_defaults_engine%:*}; \
		fmt=$${fmt_defaults_engine##*:}; \
		if $(PANDOC) test/fixtures/test-errors.md --lua-filter=$(FILTER_FILE) $$fmt_defaults -t $$fmt > /dev/null 2> symmetry_log.txt; then \
			echo "  ❌ FAIL: $$fmt should have aborted on the same invalid color as HTML, but it succeeded."; \
			rm -f symmetry_log.txt; exit 1; \
		else \
			if grep -q "CRITICAL ERROR: Undefined color keyword" symmetry_log.txt; then \
				echo "  ✅ PASS: $$fmt aborted on the same invalid color as HTML."; \
			else \
				echo "  ❌ FAIL: $$fmt crashed, but not for the expected reason."; \
				cat symmetry_log.txt; rm -f symmetry_log.txt; exit 1; \
			fi \
		fi; \
	done
	@rm -f symmetry_log.txt
	@echo "  Checking warnings (Invalid Dimension & Unit Values)..."
	@if grep -q "Invalid unit for pq-width" error_log.txt && \
	    grep -q "Invalid unit for pq-bar-width" error_log.txt && \
	    grep -q "Invalid unit for pq-padding-left" error_log.txt && \
	    grep -q "Invalid unit for pq-padding-right" error_log.txt && \
	    grep -q "Invalid unit for pq-padding-top" error_log.txt && \
	    grep -q "Invalid unit for pq-padding-bottom" error_log.txt; then \
		echo "  ✅ PASS: Caught all dimension/unit fallback warnings."; \
	else \
		echo "  ❌ FAIL: Expected dimension/unit warnings not found."; \
		cat error_log.txt; rm error_log.txt; exit 1; \
	fi
	@echo "  Checking warnings (Invalid Size Unit)..."
	@if grep -q 'Invalid unit for pq-size: "3xl"' error_log.txt; then \
		echo "  ✅ PASS: Caught obsolete semantic size warning."; \
	else \
		echo "  ❌ FAIL: Expected obsolete size warning not found."; \
		cat error_log.txt; rm error_log.txt; exit 1; \
	fi
	@echo "  Checking warnings (Invalid Color-Mix Syntax)..."
	@if grep -q "Invalid color-mix syntax" error_log.txt; then \
		echo "  ✅ PASS: Caught color-mix fallback warnings."; \
	else \
		echo "  ❌ FAIL: Expected color-mix warnings not found."; \
		cat error_log.txt; rm error_log.txt; exit 1; \
	fi
	@echo "  Checking warnings (Invalid Skip Value)..."
	@if grep -q "Invalid pq-skip value" error_log.txt; then \
		echo "  ✅ PASS: Caught semantic skip fallback warning."; \
	else \
		echo "  ❌ FAIL: Expected pq-skip warning not found."; \
		cat error_log.txt; rm error_log.txt; exit 1; \
	fi
	@rm -f error_log.txt

.PHONY: test-font
test-font: $(FILTER_FILE) test/fixtures/test-font-styles.md
	@echo "🧪 Verifying pq-font data delegation..."
	@echo "  Checking HTML: custom font names map to data-pq-font attribute..."
	@$(PANDOC) test/fixtures/test-font-styles.md --lua-filter=$(FILTER_FILE) $(DEFAULTS_HTML) -t html > font_check.txt 2>/dev/null
	@if grep -qF 'data-pq-font="Georgia"' font_check.txt; then \
		echo "  ✅ PASS: HTML delegation is correct."; \
	else \
		echo "  ❌ FAIL: Expected data-pq-font attribute not found."; \
		cat font_check.txt; rm -f font_check.txt; exit 1; \
	fi
	@rm -f font_check.txt
	@echo "  Checking LaTeX: custom font names pass to keys..."
	@if $(PANDOC) test/fixtures/test-font-styles.md --lua-filter=$(FILTER_FILE) $(DEFAULTS_LATEX) -t latex 2>/dev/null | grep -qF 'font={Georgia}'; then \
		echo "  ✅ PASS: LaTeX passes font key correctly."; \
	else \
		echo "  ❌ FAIL: Expected font={Georgia} not found."; exit 1; \
	fi
	@echo "  Checking Typst: custom font names pass to dictionary..."
	@if $(PANDOC) test/fixtures/test-font-styles.md --lua-filter=$(FILTER_FILE) $(DEFAULTS_TYPST) -t typst 2>/dev/null | grep -qF 'font: "Georgia"'; then \
		echo "  ✅ PASS: Typst passes font key correctly."; \
	else \
		echo "  ❌ FAIL: Expected font: \"Georgia\" not found."; exit 1; \
	fi

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
	@cp $(CSS_FILE) $(@D)/ 2>/dev/null || true
	$(PANDOC) $< \
		$(DEFAULTS_HTML) \
		--syntax-highlighting=$(SYNTAX_HIGHLIGHTING) \
		--output=$@

$(PREVIEWS_DIR)/typst/typst-%.pdf: test/fixtures/%.md
	@mkdir -p $(@D)
	$(PANDOC) $< \
		$(DEFAULTS_TYPST) \
		--syntax-highlighting=$(SYNTAX_HIGHLIGHTING) \
		--to=pdf \
		--output=$@

$(PREVIEWS_DIR)/latex/latex-%.pdf: test/fixtures/%.md
	@mkdir -p $(@D)
	$(PANDOC) $< \
		$(DEFAULTS_LATEX) \
		--syntax-highlighting=$(SYNTAX_HIGHLIGHTING) \
		--to=pdf \
		--output=$@

# ==============================================================================
# Documentation System (With Dual-Engine Output Targets)
# ==============================================================================
.PHONY: docs
docs: docs/$(DEMO_NAME).html docs/$(DEMO_NAME)-latex.pdf docs/$(DEMO_NAME)-typst.pdf docs/pullquote.lua docs/pullquote.css docs/pullquote.tex docs/pullquote.typ docs/$(STANDALONE_NAME).pdf docs/$(STY_FILE) ## Build the standalone docs portal with dual-format PDFs and extension assets

docs/$(DEMO_NAME).html: $(DEMO_SRC)
	@mkdir -p $(@D)
	@cp test/assets/preview-styles.css $(@D)/ 2>/dev/null || true
	@cp $(CSS_FILE) $(@D)/ 2>/dev/null || true
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

# Copy the core distribution extension assets over to the docs folder
docs/pullquote.%: $(EXT_DIR)/pullquote.%
	@mkdir -p docs
	cp $< $@

# Edge case: Lua file handles both extension directory and proxy route
docs/pullquote.lua: $(FILTER_FILE)
	@mkdir -p docs
	cp $(EXT_DIR)/pullquote.lua $@

# docs/$(STANDALONE_NAME).pdf: $(STANDALONE_SRC) $(STY_FILE)
# 	@mkdir -p $(@D)
# 	TEXINPUTS=".:$(CURDIR):" $(LATEX) -interaction=nonstopmode -halt-on-error -output-directory=$(@D) $< > /dev/null
# 	@rm -f $(@D)/$(STANDALONE_NAME).aux $(@D)/$(STANDALONE_NAME).log
docs/$(STANDALONE_NAME).pdf: $(STANDALONE_SRC) $(STY_FILE)
	@mkdir -p $(@D)
	@cp $(STY_FILE) $(@D)/
	TEXINPUTS=".:$(CURDIR):" $(LATEX) -interaction=nonstopmode -halt-on-error -output-directory=$(@D) $< > /dev/null
	@rm -f $(@D)/$(STANDALONE_NAME).aux $(@D)/$(STANDALONE_NAME).log

docs/$(STY_FILE): $(STY_FILE)
	@mkdir -p docs
	cp $< $@

# ==============================================================================
# Housekeeping
# ==============================================================================
.PHONY: clean
clean: ## Purge all temporary assets and generated distribution instances
	rm -f docs/$(DEMO_NAME).html docs/$(DEMO_NAME)-latex.pdf docs/$(DEMO_NAME)-typst.pdf
	rm -f docs/pullquote.lua docs/pullquote.tex docs/pullquote.typ docs/pullquote.css docs/preview-styles.css
	rm -f docs/$(STANDALONE_NAME).pdf docs/$(STY_FILE)
	rm -rf $(PREVIEWS_DIR)
	rm -f $(FILTER_FILE)
	rm -f error_log.txt
