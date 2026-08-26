# Pandoc Pullquote Filter

A robust, cross-platform Lua filter for Pandoc that renders highly customizable, block-level pullquotes.

This filter ensures visually identical, beautifully formatted layouts across LaTeX (PDF), Typst (PDF), and HTML outputs from a single Markdown source. It leverages Pandoc’s `fenced_divs` extension to provide a clean, semantic authoring experience.

## Installation & Setup

1. Place `pullquote.lua` in your project's extension directory (or pass it directly to Pandoc via `--lua-filter=pullquote.lua`).
2. Ensure the `fenced_divs` extension is enabled in your Markdown input (enabled by default in Pandoc).

### Backend-Specific Requirements

* **HTML / Typst:** Fully standalone. No additional configuration required.
* **LaTeX (PDF):** Requires the `tcolorbox` package. You **must** include the provided `pullquote.tex` file in your document preamble. This file defines the custom `\begin{pullquote}` environment the filter targets.

  *Include via CLI:* `--include-in-header=pullquote.tex`

  *Include via YAML:*

  ```yaml
  header-includes:
    - \input{pullquote.tex}
  ```

## Basic Usage

Invoke the filter by creating a Fenced Div with the `.pullquote` class. By default, the text renders in italics at the large (`pq-size-l`) scale.

```markdown
::: {.pullquote}
"Typography is the craft of endowing human language with a durable visual form."
--- Robert Bringhurst
:::
```

## Global Metadata Configuration

You can establish project-wide styling defaults using YAML frontmatter or a Pandoc defaults file. The filter prioritizes inline attributes on individual Fenced Divs, but falls back to global metadata if inline attributes are absent.

```yaml
---
pq-color: "DarkSlateGray"
pq-barcolor: "CadetBlue"
pq-width: "80%"
pq-size: "pq-size-l"
pq-boxalign: "pq-box-center"
pq-align: "pq-align-center"
---
```

## Core Attributes API

These key-value attributes can be applied globally (prefixed with `pq-`) or inline directly on the Fenced Div (e.g., `::: {.pullquote width="60%" skip="1.5"}`).

| Attribute | Description | Default | Valid Inputs |
| :--- | :--- | :--- | :--- |
| `color` | The foreground color of the text. | Inherit | Hex, CSS Named, `xcolor` Mix |
| `barcolor` | The color of the decorative left border. | Inherit | Hex, CSS Named, `xcolor` Mix |
| `barwidth` | The thickness of the left border. | `4px` / `3pt` | Standard CSS/LaTeX units (`px`, `pt`) |
| `width` | The block width of the pullquote container. | `100%` | Percentages (`80%`), Absolute (`300pt`) |
| `boxalign` | The alignment of the pullquote block on the page. | `pq-box-center` | `pq-box-left`, `pq-box-center`, `pq-box-right` |
| `align` | The alignment of the text *inside* the box. | `pq-align-left` | `pq-align-left`, `pq-align-center`, `pq-align-right` |
| `size` | The font size scale of the text. | `pq-size-l` | See *Sizing Taxonomy* below |
| `skip` | Vertical line-height multiplier (spacing). | `1.0` | Decimal multiplier (e.g., `1.5`, `2.0`) |

## Typography API (Classes)

These utility classes can be added alongside `.pullquote` to modify the typography (e.g., `::: {.pullquote .pq-weight-bold .pq-style-smallcaps}`).

### Sizing Taxonomy

The filter provides a symmetrical 9-step sizing scale for exact API parity with the `fonts-and-alignment` extension. *(Note: Sizes below `pq-size-normal` are available for consistency, though rarely recommended for pullquotes).*

* `pq-size-3xs` (Extra Extra Extra Small)
* `pq-size-2xs`
* `pq-size-xs`
* `pq-size-s`
* `pq-size-normal` (Base document size)
* `pq-size-l` **(Default)**
* `pq-size-xl`
* `pq-size-2xl`
* `pq-size-3xl` (Extra Extra Extra Large)

### Font Weights, Styles, and Families

| Category | Classes | Notes |
| :--- | :--- | :--- |
| **Weights** | `.pq-weight-normal`, `.pq-weight-medium`, `.pq-weight-bold` | Overrides base weight |
| **Styles** | `.pq-style-upright`, `.pq-style-italic`, `.pq-style-slanted`, `.pq-style-smallcaps`, `.pq-style-emph` | Defaults to *italic* |
| **Families** | `.pq-family-serif`, `.pq-family-sans`, `.pq-family-mono` | Overrides base family |

## Color Syntax Rules

To ensure 100% cross-platform compatibility between LaTeX, Typst, and HTML, the filter strictly normalizes color inputs.

1. **Standard Formats:** Full Hex (`#2E8B57`), Shorthand Hex (`#666`), and standard CSS3 Named Colors (`MediumVioletRed`) are fully supported.
2. **Color Mixing:** The filter supports LaTeX's `xcolor` percentage-mixing syntax. This maps seamlessly to CSS `color-mix()` and Typst native logic.
   * *Tinting (with white):* `Color!Percentage` (e.g., `Maroon!40`)
   * *Shading (with black):* `Color!Percentage!black`
   * *Binary Mixing:* `Color1!Percentage!Color2` (e.g., `RoyalBlue!50!ForestGreen`)
3. **Casing & Limitations:** When using mix syntax, casing is strictly enforced by the LaTeX backend. Use PascalCase for CSS names (`RoyalBlue`) and lowercase for core LaTeX colors (`black`). Multi-color mixing (more than two colors) is not supported.

## Error Handling

The filter is designed to fail gracefully:

* If a missing or invalid taxonomy class is provided (e.g., `pq-size-fake`), it will log a terminal warning and fall back to the default property.
* If the `fenced_divs` extension is disabled, it will log a warning and output raw text.
* If a completely invalid or unparseable color string is passed, the filter will intentionally execute a **fatal abort** to prevent engine compilation crashes downstream.
