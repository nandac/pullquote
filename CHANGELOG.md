# Changelog

<!-- markdownlint-disable MD024 -->

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] — 2026-08-27

Initial public release of the `pullquote` Pandoc Lua filter.

### Added

- Semantic `.pullquote` fenced-div syntax that renders to HTML, LaTeX/PDF, and Typst from the same Markdown source.
- Unified, namespaced attribute API (`pq-*`) for inline configuration with fallback to global document metadata.
- Core layout attributes: `pq-width`, `pq-color`, `pq-bar-color`, `pq-bar-width`, and `pq-skip` (interline spacing multiplier).
- Typography attributes: `pq-weight`, `pq-style`, and `pq-family`.
- Symmetrical 9-step t-shirt sizing scale (`3xs` through `3xl`, featuring `m` as medium) alongside custom unit parsing via the `pq-size` attribute.
- Dual-alignment control via `pq-text-align` (inner text) and `pq-box-align` (block positioning).
- Color resolution supporting CSS named colors, 3/6-digit hex codes, and cross-platform color-mixing syntax (e.g. `Maroon!30`), rendered natively for LaTeX (`xcolor`), HTML (`color-mix`), and Typst (`color.mix`).
- Document-metadata font mapping (`pq-family-serif`, `pq-family-sans`, `pq-family-mono`, and fallback to `mainfont`/`sansfont`/`monofont`/`codefont`) for Typst output.
- LaTeX preamble (`pullquote.tex`) defining the `pullquote` `tcolorbox` environment with keyval options.
- Fully standalone Typst code generation (no external preamble required).
- Pandoc extension manifest (`_extension.yml`) for installation via `pandoc-ext`/`quarto`-style extension tooling.
- Robust `Makefile` providing multi-backend AST differential testing (`make test`), artifact previews (`make previews`), and standalone documentation generation (`make docs`).
