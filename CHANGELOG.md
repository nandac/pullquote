# Changelog

<!-- markdownlint-disable MD024 -->

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] — 2026-09-10

### Changed

- **`pq-skip` now means the same thing in Typst as it does in HTML and LaTeX**, which changes how existing Typst output renders. Typst's `par(leading)` is not a baseline-to-baseline distance like CSS's `line-height` or TeX's `\baselineskip` — it's the *gap* between line boxes, and Typst's default box runs only from the font's cap-height down to the baseline, so the box height varies per font (0.714em in Noto Serif, 0.658em in Libertinus Serif) and descenders hang into the gap. The filter had been passing the multiplier straight through as an em value, so `pq-skip="1.4"` produced 1.4x line spacing in HTML and LaTeX but roughly 2.11x in Typst — the same attribute describing a visibly different result, which forced unrelated per-engine values on any document targeting more than one output. The Typst branch now pins the line box to exactly `1em` (`top-edge: 0.8em`, `bottom-edge: -0.2em`, which keeps descender room below the baseline) and subtracts that `1em` from the requested spacing, making the box height font-independent and the attribute portable. Absolute values are handled the same way via Typst's mixed-unit length arithmetic (`pq-skip="20pt"` emits `leading: 20pt - 1em`). The Typst default is now `0.5em`, matching HTML's `1.5` line-height instead of the effective 1.71x it previously produced. **Migration:** documents that hand-tuned `pq-skip` per engine to work around the old behavior should drop the Typst-specific value and use the same number everywhere; Typst pullquotes will otherwise render tighter than before.
- README: clarified the LaTeX (`pullquote.sty`) section heading and instructions, pointing to `test/pullquote-standalone-example.tex` as the complete example.
- README/specimen CSS: simplified font setup to rely on plain `font-family`/`font-size` declarations instead of `--pq-*` custom properties.
- Added a dedicated `test-skip.md` fixture for `pq-skip` (the multiplier scale, all four unit forms, and the interaction with `pq-size`), extended `test-font-sizes.md` to cover the `pt`/`px`/`rem`/`vw` custom units it previously omitted, and gave every fixture an opening paragraph stating what it covers and what should or should not match when the HTML, LaTeX and Typst previews are compared side by side.
- Fixed the "Inline Override" case in `test-metadata-config.md`, which used unprefixed `width=`/`color=`/`barcolor=` attributes. The filter only reads `pq-`-prefixed names, so the override silently did nothing — the quote rendered with the global metadata values while the surrounding prose claimed the opposite, and Pandoc emitted the bare names into the HTML as literal attributes.
- `test/pullquote-standalone-example.tex` now configures its document the way Pandoc's default template configures the other three specimens, so the two LaTeX PDFs can actually be compared side by side. It had been using bare `\documentclass{article}` — 10pt on US Letter with indented, unspaced paragraphs and `\bfseries` headings — against the Pandoc side's 12pt A4 with `margin=20mm`, `parskip`, and Noto Serif SemiBold headings via `titlesec`. Both already applied the same `\setstretch{1.25}`, so the visibly looser line spacing in the Pandoc PDF was never a spacing difference at all: it followed entirely from the 12pt base (natural leading 14.5pt vs 10pt's 12pt). Same for the apparent font difference — both embed identical Noto Serif faces, one simply set 20% smaller. It also picks up `microtype` and `\setlength{\emergencystretch}{3em}` from that template, without which the longer `\texttt` key lists overrun the right margin at 12pt.
- The specimen and demo documents now take their build date from the `Makefile` (`--metadata=date:$(BUILD_DATE)`) instead of a hand-edited `date:` in `test/settings/shared.yaml`, so a rebuild no longer silently ships a stale date.
- `test/pullquote-standalone-example.tex` now mirrors every example in the Pandoc specimen (`test/pullquote-examples.md`), translated to `pullquote.sty`'s own `width`/`color`/`size`/`skip`/`align`/`boxalign`/`barwidth`/`barcolor`/`padding*` keys, so the LaTeX package gets the same feature coverage as the Pandoc/Quarto filter instead of just two illustrative quotes. The `\pullquote[...]` source shown before each example now renders in a dark, sharp-cornered `tcolorbox` (reusing the package it already loads) instead of a bare `verbatim` block, to look consistent with the syntax-highlighted code blocks in the other three specimens. It now also loads `\setsansfont{Noto Sans}`/`\setmonofont{Fira Mono}` (previously only `\setmainfont{Noto Serif}`), matching `test/settings/shared.yaml` exactly, so the sans/mono examples and the code boxes render in the same fonts as the other three specimens instead of silently falling back to Computer Modern; and gained a title block plus an "Introduction" section mirroring `test/pullquote-examples.md`'s own. It also now loads `setspace` and calls `\setstretch{1.25}` right after `\maketitle`, matching `test/settings/shared.yaml`'s `linestretch: 1.25` (which Pandoc's own default template turns into the identical call) — without it, the whole document's line spacing defaulted to 1.0× and read visibly tighter than the other three specimens.

### Fixed

- `pq-size` with a `px` value no longer renders a third too large in PDF. The size branch swapped the `px` suffix for `pt` without scaling the number, so `pq-size="32px"` reached both PDF engines as `32pt` instead of `24pt` — while `pq-bar-width="32px"` and `pq-padding-*="32px"` in the very same pullquote were correctly converted through `px_to_pt()` at the standard 96dpi:72pt ratio. `pq-size` now uses that same ratio. Values in `pt`/`em`/`ex`/`rem`/`vw` are unaffected.
- A pullquote that sets no `pq-text-color`/`pq-bar-color` now renders the same grey in all three engines. The filter only emits `color=`/`barcolor=` when the document actually sets those attributes, so LaTeX fell through to the `\pqsetdefaults` values in `pullquote.tex`/`pullquote.sty` — the svgnames `DarkGray` (`#A9A9A9`) and `LightGray` (`#D3D3D3`) — while HTML and Typst used `#888888` and `#d9d9d9`. Default pullquote text therefore rendered visibly lighter in PDF than on the web, and contradicted the defaults documented in the README. Both preambles now `\definecolor` the exact hex values instead, so all three engines agree. Documents that set their own colors are unaffected.
- Typst's "no sans font configured" warning no longer fires for every document missing a `sansfont` variable; it now fires at most once, and only when a pullquote actually resolves to `pq-family="sans"` without one configured.
- `mainfont`/`sansfont`/`monofont`/`codefont` are now recognized whether set via YAML frontmatter (or a defaults file's `metadata:` block) or via `-V`/a defaults file's `variables:` block; previously only the former worked, so filters run with `--defaults` configuring fonts as variables silently fell back to the built-in defaults.
- The Typst specimen template (`test/assets/preview-styles.typ`) no longer discards Pandoc's `fontsize` and `linestretch`. Its `conf()` swallowed both into `..args` and never applied them, so the body stayed at Typst's built-in 11pt default while the LaTeX and HTML pathways honored the configured 12pt. Because every `pq-size`/`pq-skip`/padding value is em-relative, that 8% base-size gap propagated into every measurement in the Typst PDFs, making pullquotes render systematically smaller there and requiring inflated per-engine `pq-size` values to compensate. Both are now named parameters and applied. The heading and frontmatter sizes in the same file, previously hardcoded in absolute points against an assumed 12pt base, are em-relative so the whole scale tracks `fontsize`. With these two fixes a single `pq-size`/`pq-skip` pair renders identically in LaTeX and Typst, to within the TeX-point vs PostScript-point definition (72.27 vs 72 per inch, a 0.375% floor neither engine can close).
- LaTeX/PDF output (via `pullquote.tex` and `pullquote.sty`) no longer over-inflates line spacing by 20% on every pullquote that doesn't set `pq-skip`/`skip` explicitly. The default `\pqskip` was `1.2\baselineskip`, evaluated *after* `\pqsize` had already reset `\baselineskip` to the chosen size's own natural leading — so the "1.2×" compounded on top of an already-correct value instead of overriding it, growing more visibly loose the larger the font size (most obvious on wrapped multi-line text at `2xl`/`3xl`/custom point sizes). The default is now `\baselineskip` (a no-op), leaving each size's own leading alone; an explicit `pq-skip`/`skip` value is unaffected.

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

[1.2.0]: https://github.com/nandac/pullquote/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/nandac/pullquote/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/nandac/pullquote/releases/tag/v1.0.0
