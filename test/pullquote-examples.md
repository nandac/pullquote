---
title: Demonstration of the Pullquote Filter for Pandoc
pq-color: "DarkSlateGray"
pq-bar-color: "CadetBlue"
pq-width: "80%"
pq-size: "l"
pq-box-align: "center"
---

## Introduction

This document showcases the features of the `pullquote` Pandoc Lua filter. Each example displays the required Markdown syntax alongside its rendered output, ensuring visually identical layouts across LaTeX (PDF), Typst (PDF), and HTML formats.

**Backend Note:** Typst and HTML outputs are fully standalone. For LaTeX output, you must include the provided `pullquote.tex` file in your document's preamble. You can do this by passing `--include-in-header=pullquote.tex` to your Pandoc command or by referencing it in your document's YAML metadata.

The extension leverages Pandoc’s `fenced_divs` extension. If this is disabled, the filter will issue a terminal warning and render the elements as raw text instead of applying the styles.

## Fenced Divs Invocations

This filter follows Pandoc’s standard conventions for container-based styling. Because pullquotes are inherently block-level elements, they are invoked exclusively using Fenced Divs with the `.pullquote` class.

```markdown
::: {.pullquote}
"Typography is the craft of endowing human language with a durable visual form."
--- Robert Bringhurst
:::
```

::: {.pullquote}
"Typography is the craft of endowing human language with a durable visual form."
--- Robert Bringhurst
:::

## Font Sizing

The extension provides a sizing scale to adjust the text relative to the document’s base font size. While the filter supports a full 9-step scale (from `3xs` to `3xl`) alongside custom arbitrary units, the larger sizes below are the most practical for pullquotes. If omitted, it defaults to the `l` (large) scale.

**Rendered Sizing Scale:**

::: {.pullquote pq-size="m"}
**pq-size="m":** Medium (Base document size)
:::

::: {.pullquote pq-size="l"}
**pq-size="l":** Large (The Default Size)
:::

::: {.pullquote pq-size="xl"}
**pq-size="xl":** Extra Large
:::

::: {.pullquote pq-size="2xl"}
**pq-size="2xl":** Extra Extra Large
:::

::: {.pullquote pq-size="3xl"}
**pq-size="3xl":** Extra Extra Extra Large
:::

::: {.pullquote pq-size="24pt"}
**pq-size="24pt":** Custom Arbitrary Dimensions
:::

### HTML Sizing Unit

For HTML output only, the `pq-html-unit` attribute controls whether the scale above resolves to root-relative `rem` units (the default) or cascading `em` units — useful if your CSS framework scales typography off `em` rather than the document root. LaTeX and Typst are unaffected, since this attribute only controls CSS unit selection.

```markdown
::: {.pullquote pq-size="l" pq-html-unit="em"}
**pq-html-unit="em":** This quote scales using em units instead of the default rem.
:::
```

::: {.pullquote pq-size="l" pq-html-unit="em"}
**pq-html-unit="em":** This quote scales using em units instead of the default rem.
:::

## Font Weights, Shapes, and Families

The extension provides predefined typographic utility attributes. These styles are mapped to equivalent rendering properties across all formats to ensure consistent output, regardless of the underlying engine.

### Font Weights

```markdown
::: {.pullquote pq-weight="bold"}
This paragraph is in bold weight.
:::
```

::: {.pullquote pq-weight="bold"}
This paragraph is in bold weight.
:::

### Font Styles

By default, pullquotes render in italics. You can override this using the style utilities.

```markdown
::: {.pullquote pq-style="upright"}
This paragraph is explicitly rendered upright (non-italicized).
:::
```

::: {.pullquote pq-style="upright"}
This paragraph is explicitly rendered upright (non-italicized).
:::

### Font Families

`pq-family="serif"`/`"sans"`/`"mono"` resolves to the same `mainfont`/`sansfont`/`monofont` (or `codefont` for mono) across LaTeX, Typst, and HTML, so a pullquote always matches the rest of your document — there's no separate font to configure per format.

```markdown
::: {.pullquote pq-family="serif"}
This paragraph is in serif.
:::

::: {.pullquote pq-family="sans"}
This paragraph is in sans-serif.
:::

::: {.pullquote pq-family="mono"}
This paragraph is in monospace.
:::
```

::: {.pullquote pq-family="serif"}
This paragraph is in serif.
:::

::: {.pullquote pq-family="sans"}
This paragraph is in sans-serif.
:::

::: {.pullquote pq-family="mono"}
This paragraph is in monospace.
:::

`pq-family` defaults to `serif` when omitted, so an un-styled pullquote already matches your document's `mainfont` without needing `pq-family="serif"` explicitly.

### Custom Font Names

Any value other than `serif`, `sans`, or `mono` is treated as a literal font name, applied directly instead of going through `mainfont`/`sansfont`/`monofont` — useful for giving one specific pullquote its own distinct look, independent of the rest of the document.

```markdown
::: {.pullquote pq-family="Libre Baskerville"}
This pullquote uses a specific display font, independent of the document's mainfont.
:::
```

::: {.pullquote pq-family="Libre Baskerville"}
This pullquote uses a specific display font, independent of the document's mainfont.
:::

> **No Font Validation:** The filter does not check whether the named font actually exists — if it isn't available, LaTeX's `fontspec` raises a hard compile error, while Typst warns and substitutes a fallback. Neither is caught by this filter; both are the engine's own native behavior.

<!-- -->

> **Typst Note:** Typst ships no default sans-serif font. If you use `pq-family="sans"` with Typst output, set `sansfont` in your metadata explicitly — otherwise the filter falls back to a best-effort chain (`Noto Sans`, `DejaVu Sans`, `Liberation Sans`, `Arial`, `Helvetica`) and emits a warning to `stderr`.

## Colors and Borders

This section describes how to apply colors to the pullquote text and its decorative left border. The filter normalizes color inputs to ensure they render identically across LaTeX, Typst, and HTML.

### Basic Color Attributes

Use `pq-color` for the text, `pq-bar-color` for the left border, and `pq-bar-width` to adjust the border's thickness.

```markdown
::: {.pullquote pq-color="CadetBlue" pq-bar-color="Thistle" pq-bar-width="0.5rem"}
This quote uses the SVG named color **CadetBlue** for text and the pastel **Thistle** for a thick 0.5rem border.
:::
```

::: {.pullquote pq-color="CadetBlue" pq-bar-color="Thistle" pq-bar-width="0.5rem"}
This quote uses the SVG named color **CadetBlue** for text and the pastel **Thistle** for a thick 0.5rem border.
:::

### Bar Spacing

The `pq-padding-left` attribute controls the gap between the bar and the quote text, independent of the bar's own thickness (`pq-bar-width`).

```markdown
::: {.pullquote pq-bar-width="0.5rem" pq-padding-left="1.5rem"}
This quote widens the gap between the bar and the text using **pq-padding-left="1.5rem"**, independent of the 0.5rem bar thickness.
:::
```

::: {.pullquote pq-bar-width="0.5rem" pq-padding-left="1.5rem"}
This quote widens the gap between the bar and the text using **pq-padding-left="1.5rem"**, independent of the 0.5rem bar thickness.
:::

The remaining three sides — `pq-padding-right`, `pq-padding-top`, and `pq-padding-bottom` — can each be tuned independently of `pq-padding-left`, giving full control over the box's inner spacing.

```markdown
::: {.pullquote pq-bar-color="SeaGreen" pq-padding-left="1rem" pq-padding-right="1rem" pq-padding-top="1rem" pq-padding-bottom="1rem"}
This quote sets an even 1rem of padding on every side, giving the text room to breathe on all edges rather than just next to the bar.
:::
```

::: {.pullquote pq-bar-color="SeaGreen" pq-padding-left="1rem" pq-padding-right="1rem" pq-padding-top="1rem" pq-padding-bottom="1rem"}
This quote sets an even 1rem of padding on every side, giving the text room to breathe on all edges rather than just next to the bar.
:::

### Hex Codes

The filter fully supports 6-character hex codes and 3-character shorthands.

```markdown
::: {.pullquote pq-color="#827397" pq-bar-color="#FAA"}
This quote uses raw Hex codes: **#827397** for text and the shorthand **#FAA** (Soft Coral) for the bar.
:::
```

::: {.pullquote pq-color="#827397" pq-bar-color="#FAA"}
This quote uses raw Hex codes: **#827397** for text and the shorthand **#FAA** (Soft Coral) for the bar.
:::

### Color Mixing

The extension supports LaTeX’s `xcolor` percentage-mixing syntax. This maps reliably across Typst, LaTeX, and HTML (which leverages the native CSS `color-mix()` function).

```markdown
::: {.pullquote pq-color="Indigo!90!Black" pq-bar-color="Indigo!20" pq-bar-width="0.375rem"}
This quote uses a three-part blend for the text (**Indigo mixed at 90% with Black**) and a standard two-part blend with white for the bar.
:::
```

::: {.pullquote pq-color="Indigo!90!Black" pq-bar-color="Indigo!20" pq-bar-width="0.375rem"}
This quote uses a three-part blend for the text (**Indigo mixed at 90% with Black**) and a standard two-part blend with white for the bar.
:::

## Block-Level Positioning and Width

By adjusting `pq-width` and `pq-box-align`, we can position the entire pullquote block to the left, center, or right of the page. This shifts the block within the standard document flow; the body text will sit above and below it rather than wrapping around it.

```markdown
::: {.pullquote pq-width="45%" pq-box-align="right"}
This quote takes up 45% of the page width and is aligned flush to the right margin.
:::
```

::: {.pullquote pq-width="45%" pq-box-align="right"}
This quote takes up 45% of the page width and is aligned flush to the right margin.
:::

*(Absolute units such as `pq-width="300pt"` or `pq-width="10cm"` are also fully supported).*

## Inner Text Alignment

The `pq-text-align` attribute controls text alignment *within* the Fenced Div.

```markdown
::: {.pullquote pq-text-align="center" pq-width="70%" pq-box-align="left"}
This quote takes up 70% of the page and is aligned to the left margin, but the text *inside* the box is centered.
:::
```

::: {.pullquote pq-text-align="center" pq-width="70%" pq-box-align="left"}
This quote takes up 70% of the page and is aligned to the left margin, but the text *inside* the box is centered.
:::

## Interline Spacing (Line-Height)

The `pq-skip` attribute allows you to adjust the vertical space between lines of text. While casually referred to as leading, `pq-skip` technically acts as a multiplier for the engine's interline spacing (`line-height` in CSS, `\baselineskip` in LaTeX, and `leading` in Typst). This is particularly useful for dense multi-line quotes or when using very large custom font sizes.

```markdown
::: {.pullquote pq-size="xl" pq-skip="2.0"}
This quote uses a `pq-skip` value of 2.0, acting as a double-spacing multiplier to let the text breathe.
:::
```

::: {.pullquote pq-size="xl" pq-skip="2.0"}
This quote uses a `pq-skip` value of 2.0, acting as a double-spacing multiplier to let the text breathe.
:::

## Global Metadata Configuration

You can establish project-wide defaults for your pullquotes using YAML frontmatter or a Pandoc defaults file. The filter checks for inline attributes first; if none exist, it falls back to the global metadata.

For example, if your document includes the following YAML frontmatter:

```yaml
---
pq-color: "DarkSlateGray"
pq-bar-color: "CadetBlue"
pq-width: "80%"
pq-size: "l"
pq-box-align: "center"
---
```

A pullquote with no inline attributes will automatically inherit those exact styles:

```markdown
::: {.pullquote}
This quote has no inline attributes. It inherits its styling entirely from the YAML frontmatter defined at the top of this document.
:::
```

::: {.pullquote}
This quote has no inline attributes. It inherits its styling entirely from the YAML frontmatter defined at the top of this document (Centered, 80% width, Large size, DarkSlateGray text, CadetBlue bar).
:::

## Combining Multiple Attributes

Multiple typographic utilities and attributes can be combined within the same element. Font, size, color, and alignment compose independently.

```markdown
::: {.pullquote pq-weight="bold" pq-family="serif" pq-style="slanted" pq-size="3xl" pq-text-align="center" pq-box-align="center" pq-width="95%" pq-color="DarkSlateBlue" pq-bar-color="PowderBlue" pq-bar-width="0.75rem" pq-padding-left="1.25rem" pq-skip="2.0"}
The Ultimate Stress Test
:::
```

::: {.pullquote pq-weight="bold" pq-family="serif" pq-style="slanted" pq-size="3xl" pq-text-align="center" pq-box-align="center" pq-width="95%" pq-color="DarkSlateBlue" pq-bar-color="PowderBlue" pq-bar-width="0.75rem" pq-padding-left="1.25rem" pq-skip="2.0"}
The Ultimate Stress Test
:::
