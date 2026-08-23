# Changelog

<!-- markdownlint-disable MD024 -->

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] — 2026-08-23

Initial public release of the `pullquote` Pandoc Lua filter.

### Added

- Semantic `.pullquote` fenced-div syntax that renders to HTML, LaTeX/PDF, and Typst from the same Markdown source.
- Attribute-driven controls for width, text color, bar color, bar width, and spacing skip.
- Size scale (`pq-size-3xs` through `pq-size-5xl`) and text-alignment classes (`pq-align-left`, `pq-align-center`, `pq-align-right`).
- Box-alignment classes (`pq-box-left`, `pq-box-center`, `pq-box-right`) for positioning the quote within the page.
- Font style and family classes covering weight, italic/oblique/small-caps styles, and serif/sans/mono families, with per-format defaults when unset.
- Color resolution supporting CSS named colors, 3/6-digit hex codes, and cross-platform color-mixing syntax (e.g. `Maroon!30`), rendered natively for LaTeX (`xcolor`), HTML (`color-mix`), and Typst (`color.mix`).
- Document-metadata font mapping (`pq-family-serif`, `pq-family-sans`, `pq-family-mono`, and fallback to `mainfont`/`sansfont`/`monofont`/`codefont`) for Typst output.
- LaTeX preamble (`pq-preamble.tex`) defining the `pullquote` `tcolorbox` environment with keyval options.
- Typst preamble (`pq-preamble.typ`) defining the `#pullquote(...)` function matching the LaTeX and HTML defaults.
- Pandoc extension manifest (`_extension.yml`) for installation via `pandoc-ext`/`quarto`-style extension tooling.
- Test suite with fixtures and expected native output for HTML, LaTeX, and Typst targets, run via `make test`.
- CI workflow running the test suite against the latest Pandoc Docker image on pushes, pull requests, and a weekly schedule.

[1.0.0]: https://github.com/nandac/pullquote/releases/tag/v1.0.0
