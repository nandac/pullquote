# Pandoc Pullquote Filter

Pullquote is a robust, cross-platform Lua filter for Pandoc that brings rich, typographic control to block-level excerpts. It ensures beautiful and consistent results across LaTeX (PDF), Typst (PDF), and HTML formats using a unified, namespaced attribute system (`pq-*`).

* **LaTeX/PDF Output:** Automatically maps `pq-*` attributes to a highly customizable `tcolorbox` environment.
* **HTML & Typst/PDF Output:** Fully standalone, generating native CSS and Typst block styles directly in the rendered markup.

* [Live HTML Specimen (Rendered Preview)](https://htmlpreview.github.io/?https://github.com/nandac/pullquote/blob/main/docs/pullquote-examples.html)
* [LaTeX PDF Specimen](https://github.com/nandac/pullquote/blob/main/docs/pullquote-examples-latex.pdf)
* [Typst PDF Specimen](https://github.com/nandac/pullquote/blob/main/docs/pullquote-examples-typst.pdf)

---

## Installation & Requirements

Requires **Pandoc 3.10 or later** and the `fenced_divs` extension (enabled by default). The filter will halt compilation with a clear error if run under an older release.

### Quarto

Install the extension via terminal. Quarto handles all asset registration automatically:

```bash
quarto add nandac/pullquote
```

### Pandoc

Download the Lua filter (and the LaTeX preamble) directly into your project directory:

```bash
# pullquote.lua (Required for all formats)
curl -O '[https://raw.githubusercontent.com/nandac/pullquote/refs/tags/v1.1.0/_extensions/pullquote/pullquote.lua](https://raw.githubusercontent.com/nandac/pullquote/refs/tags/v1.1.0/_extensions/pullquote/pullquote.lua)'

# pullquote.tex (Required ONLY for LaTeX output)
curl -O '[https://raw.githubusercontent.com/nandac/pullquote/refs/tags/v1.1.0/_extensions/pullquote/pullquote.tex](https://raw.githubusercontent.com/nandac/pullquote/refs/tags/v1.1.0/_extensions/pullquote/pullquote.tex)'
```

*See the [Compilation Commands](#compilation-commands) section below for exact terminal usage.*

---

## Basic Usage

The filter uses native Pandoc **Fenced Divs** paired with the `.pullquote` class. By default, with no attributes, the text renders in italics at the large (`l`) scale with a neutral grey bar.

```markdown
::: {.pullquote}
"Typography is the craft of endowing human language with a durable visual form."
--- Robert Bringhurst
:::
```

You can customize the output by adding inline `pq-*` attributes directly to the div:

```markdown
::: {.pullquote pq-text-color="DarkSlateGray" pq-bar-color="CadetBlue" pq-size="xl"}
"Typography is the craft of endowing human language with a durable visual form."
:::
```

---

## Attributes & Examples

### Colors & Borders

Supports CSS3 named colors (case-insensitive) and hex codes. It also natively supports LaTeX's `xcolor` percentage mixing (e.g., `Maroon!30`) across **all** formats (HTML and Typst included).

| Attribute | Description | Default |
| :--- | :--- | :--- |
| `pq-text-color` | Text foreground color | `#888888` |
| `pq-bar-color` | Left border color | `#d9d9d9` |
| `pq-bar-width` | Left border thickness | `0.25em` (HTML) / `4pt` |

**Example:**

```markdown
::: {.pullquote pq-text-color="crimson" pq-bar-color="crimson!30" pq-bar-width="6px"}
This pullquote uses a solid crimson text color and a 30% tinted crimson bar.
:::
```

### Spacing & Padding

You have granular control over the padding on all four sides of the text, as well as the interline spacing (leading).

| Attribute | Description | Default |
| :--- | :--- | :--- |
| `pq-padding-left` | Space between the bar and text | `1em` (HTML) / `12pt` |
| `pq-padding-right` | Space on the right edge | `0` |
| `pq-padding-top` | Space above the text | `0.25em` (HTML) / `4pt` |
| `pq-padding-bottom` | Space below the text | `0.25em` (HTML) / `4pt` |
| `pq-skip` | Interline spacing multiplier | `1.0` |
| `pq-html-unit` | Base CSS unit for scaling (HTML only) | `rem` (Valid: `rem`, `em`) |

> **Design Note:** For HTML, `pq-padding-*` and `pq-bar-width` default to relative `em` units. This ensures the bar thickness and inner padding grow or shrink proportionally if you drastically change the `pq-size`. LaTeX and Typst use fixed `pt` defaults, as their box frameworks resolve dimensions differently.

**Example:**

```markdown
::: {.pullquote pq-padding-left="24px" pq-padding-top="16px" pq-skip="1.5"}
This text has custom padding on the top and left, with a 1.5x line-height multiplier.
:::
```

### Layout & Alignment

Separate controls exist for the text *inside* the box, and the box itself *on the page*.

| Attribute | Description | Default |
| :--- | :--- | :--- |
| `pq-width` | Container block width | `80%` (Accepts `%` or `pt`) |
| `pq-text-align` | Aligns text *inside* the box | `left` (Valid: `left`, `center`, `right`) |
| `pq-box-align` | Aligns the entire box on the page | `center` (Valid: `left`, `center`, `right`) |

**Example:**

```markdown
::: {.pullquote pq-width="60%" pq-box-align="right" pq-text-align="center"}
This is a 60% width pullquote pushed to the right side of the page, with centered text.
:::
```

### Typography (`pq-size`, `pq-weight`, `pq-style`, `pq-family`)

The filter features a robust, unit-agnostic sizing engine.

* **Standard Scale:** Uses a 9-step scale (`3xs` through `3xl`). `m` matches your document's baseline; `l` is the default.
* **Custom Dimensions:** You can pass standard units (`pt`, `em`, `rem`, `px`, `vw`). For example, `pq-size="24pt"` or `pq-size="1.5rem"`. The filter safely translates web units to PDF units for LaTeX/Typst to prevent crashes.

| Attribute | Default | Valid Inputs |
| :--- | :--- | :--- |
| `pq-size` | `l` | `3xs` to `3xl`, or exact units (e.g., `24pt`, `1.5em`) |
| `pq-weight` | `normal` | `normal`, `medium`, `bold` |
| `pq-style` | `italic` | `upright`, `italic`, `slanted`, `smallcaps`, `emph` |
| `pq-family` | `serif` | `serif`, `sans`, `mono`, or a literal font name |

**Example (Using Document Fonts):**

```markdown
::: {.pullquote pq-size="2xl" pq-weight="bold" pq-style="smallcaps" pq-family="sans"}
This uses the document's global sans-serif font, rendered extra-large and bold.
:::
```

**Example (Using an Independent Display Font):**

If you pass a literal string to `pq-family`, the pullquote will use that exact font, independent of the rest of your document. *(Note: Ensure the font is actually installed on your system, or LaTeX will throw a `fontspec` error).*

```markdown
::: {.pullquote pq-family="Playfair Display" pq-style="upright"}
This pullquote overrides the document base and explicitly requests Playfair Display.
:::
```

---

## Global Configuration

Instead of writing attributes on every Fenced Div, you can establish project-wide defaults in your YAML frontmatter or a Pandoc `defaults.yaml` file. Inline attributes always override these global defaults.

```yaml
metadata:
  pq-text-color: "DarkSlateGray"
  pq-bar-color: "CadetBlue"
  pq-width: "80%"
  pq-size: "l"
  pq-box-align: "center"
  pq-text-align: "center"
```

---

## Advanced: Global Font Configuration

To establish a consistent typographic baseline across all formats, define Pandoc's standard font variables directly in your Markdown frontmatter. The Lua filter automatically intercepts these variables so your `pq-family="serif"` / `"sans"` / `"mono"` calls perfectly match the rest of your document.

### PDF and Typst

```yaml
metadata:
  fontsize: 12pt
  mainfont: Noto Serif
  sansfont: Noto Sans
  monofont: Fira Mono
```

> **Typst Sans-Serif Note:** Typst bundles default serif and monospace fonts, but ships no default sans-serif font. If you use `pq-family="sans"` in Typst, you *must* set `sansfont` in your metadata. Otherwise, the filter uses a best-effort fallback chain (`Noto Sans`, `Arial`, etc.), which may not render consistently across all machines.

### HTML and Web Fonts

For HTML output, loading a webfont in your CSS is not enough. The Lua filter reads Pandoc's *metadata*, not your stylesheet. To ensure your HTML pullquotes inherit your custom fonts, declare them in *both* your CSS and your YAML metadata:

```css
@import url('[https://fonts.googleapis.com/css2?family=Noto+Serif:ital,wght@0,100..900;1,100..900&display=swap](https://fonts.googleapis.com/css2?family=Noto+Serif:ital,wght@0,100..900;1,100..900&display=swap)');

body {
  font-size: 1rem;
  font-family: 'Noto Serif', serif;
}
```

> **CSS Specificity:** For HTML output, the Lua filter writes styles directly to the element's inline `style` attribute with `!important` to guarantee survival against aggressive themes (like Bootstrap). Consequently, you cannot override pullquote properties from your external CSS stylesheet; you must configure them using `pq-*` attributes.

---

## Compilation Commands

If you are using **Quarto**, execute `quarto render document.qmd`.
If you are using **Pandoc**, pass the assets via the command line:

### PDF Generation (LaTeX)

Requires explicitly including the `pullquote.tex` preamble:

```bash
pandoc \
  --lua-filter=pullquote.lua \
  --include-in-header=pullquote.tex \
  --pdf-engine=lualatex \
  --output=document.pdf \
  document.md
```

### Typst & HTML Generation

Typst and HTML are fully standalone and require no external templates:

```bash
pandoc \
  --lua-filter=pullquote.lua \
  --pdf-engine=typst \
  --output=document.pdf \
  document.md
```

---

## Troubleshooting

* **LaTeX compilation fails with "Environment pullquote undefined":** You are missing the required `tcolorbox` definition. Ensure you are passing `--include-in-header=pullquote.tex`.
* **LaTeX compilation fails with "Package fontspec Error: The font ... cannot be found":** You set `pq-family` to a specific display font that is not installed on your system. Install the font or revert to `serif`/`sans`/`mono`.
* **The filter throws a "CRITICAL ERROR: Undefined color keyword":** You provided an invalid CSS color name or malformed hex code. The filter halts to prevent an upstream crash.
* **Pullquotes render as unformatted text (`::: {.pullquote}`):** The Pandoc `fenced_divs` extension is disabled. Enable it by passing `-f markdown+fenced_divs`.

## Changelog

See the [CHANGELOG](CHANGELOG.md) for release history and notable changes to the filter.

## License

MIT — see `LICENSE` for the full text.
