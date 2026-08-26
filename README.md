# Pandoc Pullquote Filter

Pullquote is a robust, cross-platform Lua filter for Pandoc that brings rich, typographic control to block-level excerpts, ensuring beautiful and consistent results across LaTeX (PDF), Typst (PDF), and HTML formats using a unified namespaced class system (`pq-*`).

* **LaTeX/PDF Output:** Automatically maps `pq-*` classes and attributes to a highly customizable `tcolorbox` environment.
* **HTML & Typst Output:** Fully standalone, generating native CSS and Typst block styles directly in the rendered markup.

The repository includes complete specimen documents demonstrating every feature provided by the filter. Each example showcases the exact Markdown syntax used to generate the output, making the specimens useful both as a feature showcase and as a direct library of copy-and-paste examples.

* [Live HTML Specimen (Rendered Preview)](docs/pullquote-filter.html)
* [LaTeX PDF Specimen](docs/pullquote-filter-latex.pdf)
* [Typst PDF Specimen](docs/pullquote-filter-typst.pdf)

## Extension Requirements

The filter relies completely on Pandoc's `fenced_divs` extension, which is enabled by default in modern Pandoc distributions.

> ⚠️ **Important:** In the unlikely event that this extension is explicitly disabled in your workflow, the Lua filter will emit a warning to `stderr` and ignore the custom elements, causing them to appear as unformatted raw text in your rendered output.

## Feature Highlights

* **Nine-step font sizing scale** — `pq-size-3xs` through `pq-size-3xl` for perfect API parity with `fonts-and-alignment`.
* **Font weights, shapes, and families** — bold, medium, italic, slanted, upright, emphasis, serif, sans, mono, and normal.
* **Color support** — solid CSS3/hex colors with permissive parsing, plus native `xcolor` percentage-based color mixing across all formats.
* **Text alignment and block positioning** — separate controls for text alignment *within* the pullquote and horizontal positioning of the block itself on the page.
* **Line-height controls** — native vertical spacing multipliers via the `skip` attribute.

## Installation

### Quarto

Install the extension using [Quarto](https://quarto.org):

```bash
quarto add nandac/pullquote
```

The extension automatically handles asset registration for all supported formats, including injecting the required `pullquote.tex` file for LaTeX/PDF generation.

### Pandoc

Download the filter and the LaTeX preamble directly into your project directory:

```bash
# pullquote.lua (Required for all formats)
curl -O https://raw.githubusercontent.com/nandac/pullquote/refs/tags/v1.0.0/_extensions/pullquote/pullquote.lua

# pullquote.tex (Required ONLY for LaTeX output)
curl -O https://raw.githubusercontent.com/nandac/pullquote/refs/tags/v1.0.0/_extensions/pullquote/pullquote.tex
```

Unlike Quarto, Pandoc requires you to explicitly pass these assets as arguments during compilation. See the [Compilation and Usage](#compilation-and-usage) section below for exact terminal commands.

## Configuration (Global Metadata)

You can establish project-wide styling defaults for your pullquotes using YAML frontmatter or a Pandoc defaults file. The filter prioritizes inline attributes applied directly to the Fenced Div, but falls back to this global metadata if inline attributes are absent.

### Example: YAML frontmatter

```yaml
---
title: My Example Document
pq-color: "DarkSlateGray"
pq-barcolor: "CadetBlue"
pq-width: "80%"
pq-size: "pq-size-l"
pq-boxalign: "pq-box-center"
pq-align: "pq-align-center"
---
```

### Example: Pandoc Defaults File (`defaults.yaml`)

```yaml
metadata:
  pq-color: "DarkSlateGray"
  pq-barcolor: "CadetBlue"
  pq-width: "80%"
  pq-size: "pq-size-l"
  pq-boxalign: "pq-box-center"
  pq-align: "pq-align-center"
```

## Markdown Syntax

The filter uses native Pandoc **Fenced Divs** to apply styles. Best used for styling excerpts, quotes, or multi-line highlighted sections. By default, the text renders in italics at the large (`pq-size-l`) scale.

```markdown
::: {.pullquote .pq-style-smallcaps width="60%" color="DarkSlateGray"}
"Typography is the craft of endowing human language with a durable visual form."
--- Robert Bringhurst
:::
```

## Compilation and Usage

If you are using **Quarto**, no special compilation configuration is needed—simply execute `quarto render document.qmd`. For **Pandoc**, apply the filter and assets via the command line.

### PDF Generation (LaTeX)

Compile using the Lua filter and explicitly include the `pullquote.tex` preamble file:

```bash
pandoc \
  --lua-filter=pullquote.lua \
  --include-in-header=pullquote.tex \
  --pdf-engine=lualatex \
  --output=document.pdf \
  document.md
```

### HTML & Typst Generation

HTML and Typst outputs are fully standalone and do not require external stylesheets or templates:

### Example: Typst Generation

```bash
pandoc \
  --lua-filter=pullquote.lua \
  --pdf-engine=typst \
  --output=document.pdf \
  document.md
```

### Example: HTML Generation

```bash
pandoc \
  --lua-filter=pullquote.lua \
  --standalone \
  --output=document.html \
  document.md
```

Alternatively you may specify these options in a Pandoc defaults file to reduce the number of command line arguments.

## Class Reference

### Font Sizing

Nine sizing hooks, mirroring the standard typographic scale.

| Class | LaTeX Equivalent | Size (em) | Description |
| -------- | -------- | -------- | -------- |
| `pq-size-3xs` | `\tiny` | `0.5em` | Extra Extra Extra Small |
| `pq-size-2xs` | `\scriptsize` | `0.6667em` | Extra Extra Small |
| `pq-size-xs` | `footnotesize` | `0.8333em` | Extra Small |
| `pq-size-s` | `\small`| `0.9125em` | Small |
| `pq-size-normal` | `\normalsize` | `1.0em` | Normal (Base document size) |
| `pq-size-l` | `\large` | `1.2em` | **Large (Default)** |
| `pq-size-xl` | `\Large` | `1.44em` | Extra Large |
| `pq-size-2xl` | `\LARGE` | `1.728em` | Extra Extra Large |
| `pq-size-3xl` | `\huge` | `2.0736em` | Extra Extra Extra Large |

### Font Weight, Shape, and Family

| Category | Classes | Notes |
| :--- | :--- | :--- |
| **Weights** | `.pq-weight-normal`, `.pq-weight-medium`, `.pq-weight-bold` | Overrides base weight |
| **Styles** | `.pq-style-upright`, `.pq-style-italic`, `.pq-style-slanted`, `.pq-style-smallcaps`, `.pq-style-emph` | Defaults to *italic* |
| **Families** | `.pq-family-serif`, `.pq-family-sans`, `.pq-family-mono` | Overrides base family |

## Core Attributes Reference

Apply these key-value attributes globally (prefixed with `pq-`) or inline on the div.

| Attribute | Description | Default | Valid Inputs |
| :--- | :--- | :--- | :--- |
| `barwidth` | Left border thickness | `4px` / `3pt` | CSS/LaTeX units (`px`, `pt`) |
| `width` | Container block width | `100%` | Percentages (`80%`), Absolute (`300pt`) |
| `skip` | Vertical line-height multiplier | `1.0` | Decimal (e.g., `1.5`, `2.0`) |

## Color

The `color` (text) and `barcolor` (left border) attributes support both solid values and percentage-based mixing.

### Solid Colors

Accepts CSS3 named colors and hexadecimal values. Solid color names are completely case-insensitive and parsed permissively.

```markdown
::: {.pullquote color="crimson" barcolor="#2E8B57"}
Solid color example.
:::
```

### Color Mixing

The filter natively supports LaTeX's `xcolor` percentage syntax. This translates perfectly to cross-format blending using native CSS and Typst logic. The mixing syntax uses the exclamation mark (`!`) to separate values:

| Mixing Type | Syntax Pattern | Description |
| :--- | :--- | :--- |
| Tinting | `BaseColor!Percentage` | Blends with white. `Maroon!30` keeps 30% Maroon and 70% white. |
| Shading | `BaseColor!Percentage!black` | Blends with black. |
| Two-Color Mix | `BaseColor!Percentage!MixColor` | Blends two specific colors. |

> ⚠️ **Strict Casing Rule:** Mixed color definitions are case-sensitive. The core LaTeX colors (`black`, `white`, etc.) must be written in **lowercase**. Conversely, CSS3 named colors must be written in **PascalCase** to maintain cross-backend compatibility.

## Block Positioning & Text Alignment

The filter separates the alignment of the text from the positioning of the block itself.

| Attribute | Valid Inputs | Behavior |
|--------|--------|--------|
| `align` | `pq-align-left`, `pq-align-center`, `pq-align-right` | Aligns the text *inside* the pullquote box. |
| `boxalign` | `pq-box-left`, `pq-box-center`, `pq-box-right` | Aligns the entire block on the page margin. |

## Troubleshooting

### LaTeX PDF compilation fails with "Environment pullquote undefined"

You are missing the required `tcolorbox` definition. Ensure you have downloaded `pullquote.tex` and are explicitly passing it to Pandoc using `--include-in-header=pullquote.tex`.

### The filter throws a "CRITICAL ERROR: Undefined color keyword" and crashes

You have provided a color string that the underlying rendering engines cannot parse (like a typo in a Hex code or an invalid color name). The filter intentionally executes a fatal abort to prevent upstream compilation crashes. Correct the color spelling to fix the build.

### My pullquote renders as raw unformatted text (`::: {.pullquote}`)

The Pandoc `fenced_divs` extension is disabled. Enable it by adding `+fenced_divs` to your input format (e.g., `-f markdown+fenced_divs`).

## License

MIT — see `LICENSE` for the full text.
