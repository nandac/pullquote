# Changelog

<!-- markdownlint-disable MD024 -->

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] — 2026-09-14

### Migration

- **`pq-family` is renamed to `pq-font`, and generic keyword resolution is gone.** `serif`/`sans`/`mono` are no longer accepted, and `mainfont`/`sansfont`/`monofont`/`codefont` document metadata is no longer consulted to resolve them. `pq-font` now always takes a literal font name (e.g. `pq-font="Georgia"`) — update any pullquotes still using `pq-family` or a generic keyword.
- **`pq-size`'s semantic scale shrank from 9 steps to 5.** `3xs`, `2xs`, `xs`, and `3xl` are removed; only `s`, `m`, `l`, `xl`, and `2xl` remain. Replace a removed step with a custom dimension (e.g. `pq-size="0.5em"`) or the nearest remaining step.
- **`pq-skip` now takes a semantic keyword or a bare multiplier, not a length.** Use `tight`, `base`, `relaxed`, `loose`, or a unitless number (e.g. `pq-skip="1.4"`) — `px`/`pt`/`rem`/`em` lengths are no longer accepted. The cross-engine default is also now a single unified `1.35` (previously each engine had its own natural default).
- Custom `pq-size` dimensions no longer accept `ex` or `vw` units — use `px`, `pt`, `rem`, or `em`.

### Added

- New companion asset files — `_extensions/pullquote/pullquote.css` and `_extensions/pullquote/pullquote.typ` — wired into `_extension.yml` per output format alongside `pullquote.tex`, so a hand-authored file now owns all rendering for its format.
- `pq-text-align` accepts a new `justify` value.

### Changed

- **"Delegated architecture" rewrite of the filter's output.** For every attribute, the Lua filter now hands off a value instead of computing final CSS/TeX/Typst itself: HTML gets CSS custom properties and `data-pq-*` attributes for `pullquote.css` to style, LaTeX gets keys for a rewritten `pullquote.tex`/`pullquote.sty` translation layer, and Typst gets named arguments to a new `#pullquote(...)` function in `pullquote.typ`.
- A document without the `fenced_divs` extension enabled now no-ops the filter entirely instead of only warning.
- Validation warnings are more specific about the actual problem (e.g. "Invalid unit for pq-width" instead of "Invalid value ... for pq-width").
- Updated test fixtures, snapshots, demo docs, and `test/settings/*.yaml` (lowercase `papersize`, added `mathfont`, wired in `pullquote.typ`) for the new API.

### Removed

- Typst's missing-sans-serif-font warning and best-effort fallback chain, along with all generic serif/sans/mono font resolution — superseded by `pq-font` always being a literal name.
- `test-errors-family.md` and the `test-family` Makefile target, replaced by `test-errors-font.md` and `test-font` to match the `pq-font` rename.

## [1.2.0] — 2026-09-11

### Migration

- **`pq-skip` adjustments:** Typst's `pq-skip` behavior now exactly matches HTML and LaTeX. If you previously hand-tuned a Typst-specific `pq-skip` value to work around rendering differences, you must drop it and use a single, unified value across all output formats. Typst pullquotes will otherwise render tighter than before.

### Changed

- Fully updated the standalone LaTeX example (`test/pullquote-standalone-example.tex`). It now mirrors every example in the Pandoc specimen and uses matching configuration (fonts, margins, spacing) for accurate side-by-side comparisons.
- Expanded test fixtures to better cover `pq-skip`, custom units for `pq-size`, and multi-engine comparisons.
- Simplified font setup in the README and specimen CSS to rely on standard `font-family`/`font-size` declarations.
- Demo documents now dynamically use the build date from the `Makefile` instead of a hardcoded value.
- Clarified LaTeX (`pullquote.sty`) instructions in the README.
- Fixed inline metadata overrides in test documents that were missing the required `pq-` prefix.

### Fixed

- Fixed an issue where `pq-size` with `px` units rendered too large in PDF outputs by applying the correct 96dpi:72pt ratio.
- Unified default colors. Unstyled pullquotes now render with the exact same gray hex values (`#888888` and `#d9d9d9`) across HTML, Typst, and LaTeX.
- Fixed font resolution so `mainfont`, `sansfont`, `monofont`, and `codefont` are correctly recognized whether passed via YAML frontmatter or command-line variables.
- Fixed LaTeX/PDF output over-inflating line spacing by 20% on pullquotes that do not explicitly set a `pq-skip` value.
- Fixed the Typst specimen template to properly apply Pandoc's `fontsize` and `linestretch` variables.
- Reduced noise from Typst's missing `sansfont` warning so it only fires once, and only when a pullquote specifically requests a sans-serif font.

## [1.1.0] — 2026-09-02

### Added

- `pq-html-unit` attribute to control the CSS unit used for scaling (`rem` or `em`).
- `pq-size` custom dimensions now support `rem`, `px`, and `vw` (with automatic conversion to PDF-safe equivalents for LaTeX/Typst).
- `pq-padding-left`, `-right`, `-top`, and `-bottom` attributes for independent inner-spacing control.
- Literal font name support for `pq-family` (e.g., `pq-family="Playfair Display"`), applied directly via `\fontspec`, CSS `font-family`, and Typst `#set text`.
- Support for 4- and 8-digit hex colors with alpha channels (transparency renders natively in HTML/Typst, ignored in LaTeX).
- Standalone `pullquote.sty` package for LaTeX environments bypassing Pandoc/Quarto.
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

[2.0.0]: https://github.com/nandac/pullquote/compare/v1.2.0...v2.0.0
[1.2.0]: https://github.com/nandac/pullquote/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/nandac/pullquote/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/nandac/pullquote/releases/tag/v1.0.0
