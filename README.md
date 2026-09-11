# Pandoc Pullquote Filter

A robust, cross-platform Lua filter for Pandoc that brings rich typographic control to block-level excerpts. It ensures beautiful and consistent results across LaTeX (PDF), Typst (PDF), and HTML formats using a unified, namespaced attribute system (`pq-*`).

**Live Previews:** [HTML](https://htmlpreview.github.io/?https://github.com/nandac/pullquote/blob/main/docs/pullquote-examples.html) | [LaTeX PDF](https://github.com/nandac/pullquote/blob/main/docs/pullquote-examples-latex.pdf) | [Typst PDF](https://github.com/nandac/pullquote/blob/main/docs/pullquote-examples-typst.pdf) | [Standalone LaTeX](https://github.com/nandac/pullquote/blob/main/docs/pullquote-standalone-example.pdf)

---

## Installation

Requires **Pandoc 3.10+** and the `fenced_divs` extension (enabled by default).

### Quarto

Quarto handles asset registration automatically:

```bash
quarto add nandac/pullquote
```

### Pandoc

Download the Lua filter and LaTeX preamble to your directory:

```bash
curl -O "https://raw.githubusercontent.com/nandac/pullquote/refs/tags/v1.2.0/_extensions/pullquote/pullquote.lua"
curl -O "https://raw.githubusercontent.com/nandac/pullquote/refs/tags/v1.2.0/_extensions/pullquote/pullquote.tex"
```

### LaTeX without Pandoc/Quarto

Download the standalone `pullquote.sty` to your `TEXINPUTS` directory:

```bash
curl -O "https://raw.githubusercontent.com/nandac/pullquote/refs/tags/v1.2.0/pullquote.sty"
```

Load with `\usepackage{pullquote}` and use `\begin{pullquote}[color=DarkSlateGray, size=\Large\itshape]` instead of `pq-*` attributes.

> **Engine Note:** To support advanced font features, the `pullquote` package requires `lualatex` or `xelatex`. It is incompatible with `pdflatex`.

---

## Basic Usage

Apply the `.pullquote` class to a Fenced Div. By default, text renders in italics at the large (`l`) scale.

```markdown
::: {.pullquote pq-text-color="DarkSlateGray" pq-bar-color="CadetBlue" pq-size="xl"}
"Typography is the craft of endowing human language with a durable visual form."
--- Robert Bringhurst
:::
```

---

## Attributes Reference

Colors support CSS3 named colors, hex codes, and LaTeX's `xcolor` mixing (e.g., `Maroon!30`).

### Colors & Borders

| Attribute | Description | Default |
| :--- | :--- | :--- |
| `pq-text-color` | Text foreground color | `#888888` |
| `pq-bar-color` | Left border color | `#d9d9d9` |
| `pq-bar-width` | Left border thickness | `0.25em` (HTML) / `4pt` |

### Spacing & Layout

| Attribute | Description | Default |
| :--- | :--- | :--- |
| `pq-padding-left` | Space between bar and text | `1em` (HTML) / `12pt` |
| `pq-padding-right` / `top` / `bottom` | Outer edge padding | `0` / `0.25em` / `0.25em` |
| `pq-skip` | Interline spacing multiplier | `1.5` (HTML, Typst) / engine natural |
| `pq-html-unit` | Base CSS unit for scaling (HTML only) | `rem` (Valid: `rem`, `em`) |
| `pq-width` | Container block width | `80%` |
| `pq-text-align` | Text alignment *inside* the box | `left` (Valid: `left`, `center`, `right`) |
| `pq-box-align` | Box alignment on the page | `center` (Valid: `left`, `center`, `right`) |

> **Note on `pq-skip`:** The engines calculate default line height slightly differently. Set `pq-skip` explicitly (e.g., `pq-skip="1.4"`) whenever the three outputs need to match exactly.

### Typography

| Attribute | Default | Valid Inputs |
| :--- | :--- | :--- |
| `pq-size` | `l` | `3xs` to `3xl`, or exact units (e.g., `24pt`, `1.5em`) |
| `pq-weight` | `normal` | `normal`, `medium`, `bold` |
| `pq-style` | `italic` | `upright`, `italic`, `slanted`, `smallcaps`, `emph` |
| `pq-family` | `serif` | `serif`, `sans`, `mono`, or a literal font name |

> **Note on `pq-family`:** Standard keywords (`serif`, `sans`, `mono`) inherit from your Pandoc YAML document fonts. Literal font names (e.g., `"Playfair Display"`) apply that exact font but require LuaLaTeX/XeLaTeX.

---

## Global Configuration

You can establish project-wide defaults in your YAML frontmatter. Inline attributes will override these defaults.

```yaml
metadata:
  pq-text-color: "DarkSlateGray"
  pq-bar-color: "CadetBlue"
  pq-width: "80%"
  pq-size: "l"
  mainfont: "Noto Serif" # Automatically inherited by pq-family="serif"
```

### HTML and Web Fonts

For HTML, the Lua filter reads Pandoc's font variables. To ensure your pullquotes inherit custom web fonts, declare them in *both* your CSS and your YAML metadata.

```css
@import url('https://fonts.googleapis.com/css2?family=Noto+Serif:ital,wght@0,100..900;1,100..900&display=swap');

:root {
  font-size: 1rem;
}

body {
  font-family: 'Noto Serif', serif;
}
```

---

## Compilation

If using **Quarto**, simply run `quarto render document.qmd`. For **Pandoc**, pass the required flags:

* **LaTeX PDF:** `pandoc --lua-filter=pullquote.lua --include-in-header=pullquote.tex --pdf-engine=lualatex -o doc.pdf doc.md`
* **Typst & HTML:** `pandoc --lua-filter=pullquote.lua --pdf-engine=typst -o doc.pdf doc.md`

---

## Troubleshooting

* **Environment pullquote undefined:** Missing `tcolorbox`. Ensure you are passing `--include-in-header=pullquote.tex`.
* **The font ... cannot be found:** You set `pq-family` to an uninstalled font.
* **Undefined control sequence `\fontspec`:** Literal font names require compiling with `--pdf-engine=lualatex` or `xelatex`.
* **CRITICAL ERROR: Undefined color keyword:** Invalid CSS color name or malformed hex code.
* **Pullquotes render as unformatted text:** The `fenced_divs` extension is disabled.

---

## Changelog

See the [CHANGELOG](CHANGELOG.md) for release history and notable changes.

## License

MIT — see `LICENSE` for the full text.
