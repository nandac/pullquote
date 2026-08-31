# Changelog

<!-- markdownlint-disable MD024 -->

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] — 2026-08-28

### Added

- `pq-html-unit` attribute to control the CSS unit used for `pq-size` scale keys on HTML output (`rem` or `em`; defaults to `rem`, validated against that allow-list).
- `pq-size` custom-dimension parsing now also accepts `rem`, `px`, and `vw` (v1.0.0 supported only `pt`, `em`, `ex`), with automatic conversion to PDF-safe equivalents for LaTeX and Typst output.
- `pq-padding-left`, `pq-padding-right`, `pq-padding-top`, and `pq-padding-bottom` attributes to control the box's inner spacing on each side independently (`px`/`pt`/`rem`/`em` units; defaults are `1em`/`12pt` for the left side, `0` for the right side, and `0.25em`/`4pt` for top and bottom).
- Test fixtures `test-padding.md` and `test-html-unit.md` covering the new padding attributes and `pq-html-unit`, plus their expected AST snapshots.
- A render-level check in `test-errors.md`/the `Makefile` for the Typst missing-sans-serif-font warning — previously untested by automation, since it only fires when rendering to Typst, a code path the AST-diff suite's `-t json` pipeline never exercises.
- A new `make test-family` render-content check (folded into `make test`), verifying `pq-family`'s `serif`/`sans`/`mono` keywords resolve to the actual configured `mainfont`/`sansfont`/`monofont` in generated HTML, and that a literal custom font name produces `\fontspec{...}` (LaTeX), the matching `font-family` (HTML), and `#set text(font: ...)` (Typst). Like the Typst sans-serif check above, none of this was previously testable via the AST-diff suite, since it asserts on actual rendered content, not just document structure.
- `pq-family` now accepts an arbitrary literal font name in addition to `serif`/`sans`/`mono` (e.g. `pq-family="Playfair Display"`), applied directly via `\fontspec` (LaTeX), `font-family` (HTML), and `#set text(font: ...)` (Typst) — bypassing `mainfont`/`sansfont`/`monofont` entirely for that one pullquote. The value isn't validated against installed fonts: an unresolvable name surfaces as LaTeX's own hard `fontspec` compile error, or as a soft warning-and-substitute in Typst — both native engine behavior, not something this filter checks.

### Changed

- `pq-bar-width`'s default changed from a fixed `4px`/`4pt` (v1.0.0) to `0.25em` for HTML and `4pt` for LaTeX/Typst, so the bar's thickness scales with whatever `pq-size` the pullquote uses instead of staying a constant size regardless of the text size around it — a flat size looked too heavy against small text and too thin against large text.
- `pq-bar-width` now validates its value against a `px`/`pt`/`rem`/`em` allow-list, instead of accepting any string unchecked as in v1.0.0 (which could pass a typo straight through to `tcolorbox`/Typst and fail with an obscure downstream compile error).
- `pq-bar-width`'s `px`→`pt` conversion for the LaTeX/Typst pathways now applies the correct 96dpi:72pt ratio (`24px` → `18pt`) instead of v1.0.0's naive suffix swap (`24px` → `24pt`, 33% too large).
- The bundled `test/pullquote-examples.md` specimen now uses `rem`/`em` throughout instead of `px`, to model scalable units as best practice; the `px`-specific test fixtures under `test/fixtures/` intentionally keep `px` values, since they're testing that exact conversion.
- `pq-family` now defaults explicitly to `"serif"` instead of applying no override at all when omitted. Previously, an un-styled pullquote simply inherited whatever font was already active at that point in the document; now it explicitly resolves through the same logic as `pq-family="serif"` (see below).
- HTML's `pq-family="serif"`/`"sans"`/`"mono"` now resolve to the actual configured `mainfont`/`sansfont`/`monofont`/`codefont` metadata (falling back to the generic `serif`/`sans-serif`/`monospace` CSS keyword only when that variable is unset), instead of always emitting the bare generic keyword regardless of configuration — bringing HTML in line with how LaTeX/Typst already resolved these. This was necessary as a companion to the default-value change above: without it, an un-styled pullquote on a page with a custom serif webfont would have silently stopped matching that font, forcing the browser's generic default serif instead (confirmed by rendering a page with a `mainfont`-configured webfont before and after).

### Fixed

- Typst output defaulted its sans-serif font to `DejaVu Sans Mono` (a monospace font) in v1.0.0; it now uses a fallback chain (`Noto Sans`, `DejaVu Sans`, `Liberation Sans`, `Arial`, `Helvetica`) and warns to `stderr` when compiling to Typst without an explicit sans font configured (`sansfont`).
- `pullquote.tex`: the `svgnames` `xcolor` option (used for the default `DarkGray`/`LightGray` colors) never actually took effect under Pandoc, because Pandoc's default LaTeX template loads `xcolor` before `--include-in-header` content runs, so `\PassOptionsToPackage{svgnames}{xcolor}` arrived too late. This broke LaTeX/PDF compilation with `Undefined color 'DarkGray'` for any document using the defaults since v1.0.0. Fixed by loading the SVG color definitions directly (`\input{svgnam.def}`).
- The README's example CSS `@import` URLs had markdown-link syntax accidentally left around them since v1.0.0 (e.g. `url('[https://...](https://...)')`), producing invalid CSS; cleaned up to plain URLs.
- `pq-width` no longer crashes with a raw Lua stack trace on a malformed percentage (e.g. `"abc%"`), a bug present since v1.0.0; it now warns and falls back to the default, consistent with how other invalid attribute values are handled.
- `pq-style` now behaves consistently with `pq-weight`/`pq-family` on an unrecognized value: it warns and inherits the surrounding formatting instead of also force-applying the italic default (v1.0.0's `pq-style` was the only one of the three that force-applied a fallback).
- LaTeX output was silently collapsing multi-paragraph pullquotes into one continuous block of text, with no visible break between paragraphs (unlike HTML and Typst, which both render normal paragraph spacing) — present since v1.0.0's `pullquote.tex`. The cause was `tcolorbox` itself resetting `\parskip` inside the box, independent of the `parskip` package loaded by the surrounding document. Fixed by restoring a paragraph gap of half the box's own (`pq-skip`-adjusted) `\baselineskip` inside the `before upper` hook — a full `\baselineskip` looked like double-spacing when combined with the existing interline gap.
- HTML output was missing `box-sizing: border-box` since v1.0.0, so any non-zero padding expanded the rendered box wider than its declared `pq-width` instead of being subtracted from it, unlike LaTeX/Typst — most visible now that every side of the padding is independently configurable. Fixed by setting `box-sizing: border-box` on the pullquote's inline style.
- `_extension.yml` declared `include-in-header: pq-preamble.tex` for PDF output since v1.0.0, but no such file has ever existed in the extension — only `pullquote.tex` does. This broke the Quarto installation path entirely: `quarto add nandac/pullquote` followed by any LaTeX/PDF render would fail looking for a nonexistent file, contradicting the README's claim that Quarto "automatically handles asset registration." Fixed by correcting the filename. Not covered by CI, since `.github/workflows/ci.yaml` only exercises the raw Pandoc CLI path, never the Quarto extension mechanism.

### Removed

- `pq-family-serif`, `pq-family-mono`, and `pq-family-sans` metadata overrides (present since v1.0.0, but never documented in the README). Typst font mapping now uses only the standard `mainfont`/`sansfont`/`monofont`/`codefont` variables — the same ones LaTeX already uses — so a pullquote's font always matches the rest of the document, with no separate Typst-specific override to configure. The one genuine gap this was working around (Typst has no bundled sans-serif font) is still handled: the fallback chain and warning when `sansfont` is unset are unchanged.

## [1.0.0] — 2026-08-27

Initial public release of the `pullquote` Pandoc Lua filter.

### Added

- Semantic `.pullquote` fenced-div syntax that renders to HTML, LaTeX/PDF, and Typst from the same Markdown source.
- Unified, namespaced attribute API (`pq-*`) for inline configuration with fallback to global document metadata.
- Core layout attributes: `pq-width`, `pq-text-color`, `pq-bar-color`, `pq-bar-width`, and `pq-skip` (interline spacing multiplier).
- Typography attributes: `pq-weight`, `pq-style`, and `pq-family`.
- Symmetrical 9-step t-shirt sizing scale (`3xs` through `3xl`, featuring `m` as medium) alongside custom unit parsing via the `pq-size` attribute.
- Dual-alignment control via `pq-text-align` (inner text) and `pq-box-align` (block positioning).
- Color resolution supporting CSS named colors, 3/6-digit hex codes, and cross-platform color-mixing syntax (e.g. `Maroon!30`), rendered natively for LaTeX (`xcolor`), HTML (`color-mix`), and Typst (`color.mix`).
- Document-metadata font mapping (`pq-family-serif`, `pq-family-sans`, `pq-family-mono`, and fallback to `mainfont`/`sansfont`/`monofont`/`codefont`) for Typst output.
- LaTeX preamble (`pullquote.tex`) defining the `pullquote` `tcolorbox` environment with keyval options.
- Fully standalone Typst code generation (no external preamble required).
- Pandoc extension manifest (`_extension.yml`) for installation via `pandoc-ext`/`quarto`-style extension tooling.
- Robust `Makefile` providing multi-backend AST differential testing (`make test`), artifact previews (`make previews`), and standalone documentation generation (`make docs`).
