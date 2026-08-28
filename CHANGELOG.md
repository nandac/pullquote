# Changelog

<!-- markdownlint-disable MD024 -->

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] — 2026-08-28

### Added

- `pq-html-unit` attribute to control the CSS unit used for `pq-size` scale keys on HTML output (`rem` or `em`; defaults to `rem`).
- `pq-size` custom-dimension parsing now also accepts `rem`, `px`, and `vw` (previously limited to `pt`, `em`, `ex`), with automatic conversion to PDF-safe equivalents for LaTeX and Typst output.
- Fallback sans-serif font chain (`Noto Sans`, `DejaVu Sans`, `Liberation Sans`, `Arial`, `Helvetica`) for Typst output when no `sansfont`/`pq-family-sans` is configured, since Typst ships no default sans-serif font.
- `pq-padding-left` attribute to control the space between the left bar and the quote text across all three engines (`px`/`pt` units; defaults to `1rem` for HTML, `12pt` for LaTeX/Typst), mirroring the existing `pq-bar-width` convention.
- `pq-padding-right`, `pq-padding-top`, and `pq-padding-bottom` attributes, so every side of the box can be tuned independently (defaults: `0` for the right side; `4px`/`4pt` for top and bottom, matching the previous hardcoded values).
- Test fixture `test-padding.md` (renamed from `test-padding-left.md`) covering all four padding sides, and `test-html-unit.md` covering `pq-html-unit`, plus their expected AST snapshots.

### Fixed

- Typst output previously defaulted its sans-serif font to `DejaVu Sans Mono` (a monospace font); it now uses the fallback chain above and warns to `stderr` when compiling to Typst without an explicit sans font configured.
- That warning no longer fires for HTML or LaTeX output — it's now scoped to Typst builds only.
- `pq-html-unit` now validates against the `rem`/`em` allow-list, warning and falling back to `rem` on invalid input instead of silently emitting a broken absolute size (e.g. `px` collapsing a relative size multiplier).
- `pullquote.tex`: the `svgnames` `xcolor` option (used for the default `DarkGray`/`LightGray` colors) never actually took effect under Pandoc, because Pandoc's default LaTeX template loads `xcolor` before `--include-in-header` content runs, so `\PassOptionsToPackage{svgnames}{xcolor}` arrived too late. This broke LaTeX/PDF compilation with `Undefined color 'DarkGray'` for any document using the defaults. Fixed by loading the SVG color definitions directly (`\input{svgnam.def}`).
- Malformed `@import url(...)` statements in the README's example CSS (stray markdown-link artifacts left an extra `)` before the closing quote).
- `pq-width` no longer crashes with a raw Lua stack trace on a malformed percentage (e.g. `"abc%"`); it now warns and falls back to the default, consistent with how other invalid attribute values are handled.
- `pq-bar-width` and the `pq-padding-*` attributes are now validated against a `px`/`pt` allow-list instead of being passed through unchecked, which previously let a typo reach `tcolorbox`/Typst and fail with an obscure downstream compile error.
- The `px`→`pt` conversion for `pq-bar-width`/`pq-padding-*` now applies the correct 96dpi:72pt ratio (`24px` → `18pt`) instead of naively swapping the unit suffix (`24px` → `24pt`, 33% too large).
- `pq-style` now behaves consistently with `pq-weight`/`pq-family` on an unrecognized value: it warns and inherits the surrounding formatting instead of also force-applying the italic default.
- HTML output was missing `box-sizing: border-box`, so non-zero padding (especially now that `pq-padding-right` can be set) expanded the rendered box wider than its declared `pq-width` — unlike LaTeX/Typst, where padding is always subtracted from the declared width. Fixed by setting `box-sizing: border-box` on the pullquote's inline style.

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
