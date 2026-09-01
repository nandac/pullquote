# Pandoc Pullquote Filter

A robust, cross-platform Lua filter for Pandoc that brings rich typographic control to block-level excerpts. It ensures beautiful and consistent results across LaTeX (PDF), Typst (PDF), and HTML formats using a unified, namespaced attribute system (`pq-*`).

* **LaTeX/PDF:** Automatically maps `pq-*` attributes to a highly customizable `tcolorbox` environment.
* **HTML & Typst/PDF:** Fully standalone, generating native CSS and Typst block styles directly in the rendered markup.

**Live Previews:** [HTML](https://htmlpreview.github.io/?https://github.com/nandac/pullquote/blob/main/docs/pullquote-examples.html) | [LaTeX PDF](https://github.com/nandac/pullquote/blob/main/docs/pullquote-examples-latex.pdf) | [Typst PDF](https://github.com/nandac/pullquote/blob/main/docs/pullquote-examples-typst.pdf) | [Plain LaTeX](https://github.com/nandac/pullquote/blob/main/docs/pullquote-standalone-example.pdf)

---

## Installation

Requires **Pandoc 3.10+** and the `fenced_divs` extension (enabled by default).

### Quarto

Quarto handles all asset registration automatically:

```bash
quarto add nandac/pullquote
```

### Pandoc

Download the Lua filter and the LaTeX preamble into your project directory:

```bash
curl -O "https://raw.githubusercontent.com/nandac/pullquote/refs/tags/v1.1.0/_extensions/pullquote/pullquote.lua"
curl -O "https://raw.githubusercontent.com/nandac/pullquote/refs/tags/v1.1.0/_extensions/pullquote/pullquote.tex"
```

*(See [Compilation](#compilation) below for command line flags).*

### Using Plain LaTeX? (No Pandoc/Quarto)

Download the standalone package to your `TEXINPUTS` directory:

```bash
curl -O "https://raw.githubusercontent.com/nandac/pullquote/refs/tags/v1.1.0/pullquote.sty"
```

Load it via `\usepackage{pullquote}` and use standard LaTeX keys instead of `pq-*` attributes (e.g., `\begin{pullquote}[color=DarkSlateGray, size=\Large\itshape]`). See the `test/` directory for a complete demo.
</details>

---

## Basic Usage

The filter uses native Pandoc **Fenced Divs** paired with the `.pullquote` class. By default, text renders in italics at the large (`l`) scale.

```markdown
::: {.pullquote pq-text-color="DarkSlateGray" pq-bar-color="CadetBlue" pq-size="xl"}
"Typography is the craft of endowing human language with a durable visual form."
--- Robert Bringhurst
:::
```

---

## Attributes Reference

### Colors & Borders

Supports CSS3 named colors, hex codes, and LaTeX's `xcolor` percentage mixing (e.g., `Maroon!30`) uniformly across **all** formats.

| Attribute | Description | Default |
| :--- | :--- | :--- |
| `pq-text-color` | Text foreground color | `#888888` |
| `pq-bar-color` | Left border color | `#d9d9d9` |
| `pq-bar-width` | Left border thickness | `0.25em` (HTML) / `4pt` |

### Spacing & Layout

Granular control over padding, line-height, and block alignment.

| Attribute | Description | Default |
| :--- | :--- | :--- |
| `pq-padding-left` | Space between the bar and text | `1em` (HTML) / `12pt` |
| `pq-padding-right` / `top` / `bottom` | Outer edge padding | `0` / `0.25em` / `0.25em` |
| `pq-skip` | Interline spacing multiplier (or exact unit) | `1.0` |
| `pq-html-unit` | Base CSS unit for scaling (HTML only) | `rem` (Valid: `rem`, `em`) |
| `pq-width` | Container block width | `80%` |
| `pq-text-align` | Aligns text *inside* the box | `left` (Valid: `left`, `center`, `right`) |
| `pq-box-align` | Aligns the entire box on the page | `center` (Valid: `left`, `center`, `right`) |

### Typography

Uses a unit-agnostic sizing engine. Pass standard scale keys (`3xs` to `3xl`) or specific physical/relative units (`24pt`, `1.5rem`).

| Attribute | Default | Valid Inputs |
| :--- | :--- | :--- |
| `pq-size` | `l` | `3xs` to `3xl`, or exact units (e.g., `24pt`, `1.5em`) |
| `pq-weight` | `normal` | `normal`, `medium`, `bold` |
| `pq-style` | `italic` | `upright`, `italic`, `slanted`, `smallcaps`, `emph` |
| `pq-family` | `serif` | `serif`, `sans`, `mono`, or a literal font name |

> **Note on `pq-family`:** Standard keywords (`serif`, `sans`, `mono`) automatically inherit from your Pandoc YAML document fonts (`mainfont`, etc.). Passing a literal font string (e.g., `pq-family="Playfair Display"`) applies that exact font but does not support CSS-style fallback chaining.

---

## Global Configuration

You can establish project-wide defaults in your YAML frontmatter. Inline attributes on the Fenced Div will override these defaults.

```yaml
metadata:
  pq-text-color: "DarkSlateGray"
  pq-bar-color: "CadetBlue"
  pq-width: "80%"
  pq-size: "l"
  mainfont: "Noto Serif" # Automatically inherited by pq-family="serif"
```

### HTML and Web Fonts

For HTML output, loading a webfont in your CSS is not enough, because the Lua filter reads Pandoc's metadata to determine the font family. To ensure your HTML pullquotes inherit your custom fonts, declare them in *both* your CSS and your YAML metadata (as shown above).

```css
@import url('https://fonts.googleapis.com/css2?family=Noto+Serif:ital,wght@0,100..900;1,100..900&display=swap');

body {
  font-size: 1rem;
  font-family: 'Noto Serif', serif;
}
```

---

## Compilation

If using **Quarto**, simply run `quarto render document.qmd`.
If using **Pandoc**, pass the required engine and assets via the command line:

**LaTeX PDF:** (Requires explicitly including the preamble)

```bash
pandoc --lua-filter=pullquote.lua --include-in-header=pullquote.tex --pdf-engine=lualatex --output=document.pdf document.md
```

**Typst & HTML:** (Fully standalone)

```bash
pandoc --lua-filter=pullquote.lua --pdf-engine=typst --output=document.pdf document.md
```

---

## Troubleshooting

* **Environment pullquote undefined:** Missing the `tcolorbox` definition. Ensure you are passing `--include-in-header=pullquote.tex`.
* **The font ... cannot be found:** You set `pq-family` to a font not installed on your system.
* **Undefined control sequence `\fontspec`:** Literal `pq-family` font names require `fontspec`, meaning you must compile with `--pdf-engine=lualatex` or `xelatex`.
* **CRITICAL ERROR: Undefined color keyword:** Invalid CSS color name or malformed hex code.
* **Pullquotes render as unformatted text:** The `fenced_divs` extension is disabled.

## Changelog

See the [CHANGELOG](CHANGELOG.md) for release history and notable changes to the filter.

## License

MIT — see `LICENSE` for the full text.
