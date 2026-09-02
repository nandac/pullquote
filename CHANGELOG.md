# Changelog

<!-- markdownlint-disable MD024 -->

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] — 2026-09-02

### Added

- `pq-html-unit` attribute to control the CSS unit used for scaling (`rem` or `em`).
- `pq-size` custom dimensions now support `rem`, `px`, and `vw` (with automatic conversion to PDF-safe equivalents for LaTeX/Typst).
- `pq-padding-left`, `-right`, `-top`, and `-bottom` attributes for independent inner-spacing control.
- Literal font name support for `pq-family` (e.g., `pq-family="Playfair Display"`), applied directly via `\fontspec`, CSS `font-family`, and Typst `#set text`.
- Support for 4- and 8-digit hex colors with alpha channels (transparency renders natively in HTML/Typst, ignored in LaTeX).
- Standalone `pullquote.sty` package for plain LaTeX environments bypassing Pandoc/Quarto.
- Expanded test coverage for padding attributes, HTML units, Typst font warnings, and literal font rendering.

### Changed

- `pq-bar-width` default changed to `0.25em` (HTML) and `4pt` (LaTeX/Typst) for proportional scaling.
- `pq-bar-width` now strictly validates against an allowed list of units (`px`/`pt`/`rem`/`em`).
- `px`-to-`pt` conversions for LaTeX/Typst now use the accurate 96dpi:72pt ratio (1px = 0.75pt).
- `pq-family` now explicitly defaults to `"serif"` instead of inheriting the surrounding un-styled font.
- HTML `pq-family` keyword resolution (`serif`/`sans`/`mono`) now reads Pandoc's standard `mainfont`/`sansfont`/`monofont` metadata to ensure consistency across PDF and HTML outputs.
- Bundled specimen documents updated to use scalable `rem`/`em` units by default.

### Fixed

- LaTeX `svgnames` color definitions now load correctly via `\input{svgnam.def}`, resolving "Undefined color" errors under default Pandoc templates.
- Multi-paragraph pullquotes in LaTeX now render with proper paragraph spacing inside the `tcolorbox`.
- HTML output now applies `box-sizing: border-box` to prevent custom padding from expanding the container width.
- Quarto extension installation path fixed by correcting the PDF include reference to `pullquote.tex` in `_extension.yml`.
- Typst output now includes a sans-serif fallback chain and emits a warning if `sansfont` is unconfigured.
- `pq-width` strictly validates length units and no longer crashes on malformed percentages.
- `pq-skip` validates units, converts `px`/`rem` to PDF-safe equivalents, and fixes the Typst leading calculation.
- `pq-style` warns and inherits surrounding formatting on invalid values instead of forcing italics.
- Unresolved color names and malformed `xcolor` mixing syntax now strictly abort compilation or fall back safely across all formats.
- `pq-size` custom-dimension parsing safely rejects `0` values.
- README CSS `@import` URLs cleaned of invalid markdown link syntax.

### Removed

- Undocumented `pq-family-serif`, `pq-family-sans`, and `pq-family-mono` metadata overrides (the filter now relies exclusively on Pandoc's standard font variables).

## [1.0.0] — 2026-08-27

Initial public release of the `pullquote` Pandoc Lua filter.

### Added

- Semantic `.pullquote` fenced-div syntax rendering to HTML, LaTeX/PDF, and Typst from the same Markdown source.
- Unified, namespaced attribute API (`pq-*`) for inline configuration with fallback to global document metadata.
- Core layout attributes: `pq-width`, `pq-text-color`, `pq-bar-color`, `pq-bar-width`, and `pq-skip`.
- Typography attributes: `pq-weight`, `pq-style`, and `pq-family`.
- Symmetrical 9-step t-shirt sizing scale (`3xs` through `3xl`) alongside custom unit parsing via `pq-size`.
- Dual-alignment control via `pq-text-align` (inner text) and `pq-box-align` (block positioning).
- Color resolution supporting CSS named colors, hex codes, and cross-platform color-mixing syntax (e.g. `Maroon!30`).
- Document-metadata font mapping for Typst output.
- LaTeX preamble (`pullquote.tex`) defining the `pullquote` `tcolorbox` environment.
- Fully standalone Typst code generation (no external preamble required).
- Pandoc extension manifest (`_extension.yml`) for `pandoc-ext`/`quarto`-style installation.
- Robust `Makefile` for multi-backend AST testing, artifact previews, and documentation generation.

[1.1.0]: https://github.com/nandac/pullquote/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/nandac/pullquote/releases/tag/v1.0.0
