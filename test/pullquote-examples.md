---
title: Demonstration of the Pullquote Filter for Pandoc
---

## Introduction

This document showcases the features of the `pullquote` Pandoc Lua filter. Each example displays the required Markdown syntax alongside its rendered output, ensuring visually identical layouts across LaTeX (PDF), Typst (PDF), and HTML formats.

**Backend Note:** The `pullquote` filter uses a delegated architecture, meaning no format is standalone. You must provide the corresponding companion file to your typesetting engine:

* **LaTeX:** Include `pullquote.tex` in your document's preamble (e.g., by passing `--include-in-header=pullquote.tex` to Pandoc or referencing it in your YAML metadata).
* **Typst:** Include `pullquote.typ` in your document's preamble (e.g., by passing `--include-in-header=pullquote.typ` to Pandoc or referencing it in your YAML metadata).
* **HTML:** Link `pullquote.css` (e.g., by passing `--css=pullquote.css` to Pandoc).

The extension leverages Pandoc’s `fenced_divs` extension. If this is disabled, the filter will issue a terminal warning and render the elements as raw text instead of applying the styles.

## Fenced Divs Invocations

In accordance with Pandoc's standard conventions for styling block elements, pullquotes must be instantiated exclusively via Fenced Divs using `.pullquote` class.

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

The extension provides a sizing scale to adjust the text relative to the document’s base font size. While the filter supports a full 5-step scale (from `s` to `2xl`) alongside custom arbitrary units, the larger sizes below are the most practical for pullquotes. If omitted, it naturally inherits the document's current font size.

**Rendered Sizing Scale:**

```markdown
::: {.pullquote pq-size="m"}
**pq-size="m":** Medium (Base document size)
:::
```

::: {.pullquote pq-size="m"}
**pq-size="m":** Medium (Base document size)
:::

```markdown
::: {.pullquote pq-size="l"}
**pq-size="l":** Large
:::
```

::: {.pullquote pq-size="l"}
**pq-size="l":** Large
:::

```markdown
::: {.pullquote pq-size="xl"}
**pq-size="xl":** Extra Large
:::
```

::: {.pullquote pq-size="xl"}
**pq-size="xl":** Extra Large
:::

```markdown
::: {.pullquote pq-size="2xl"}
**pq-size="2xl":** Extra Extra Large
:::
```

::: {.pullquote pq-size="2xl"}
**pq-size="2xl":** Extra Extra Large
:::

```markdown
::: {.pullquote pq-size="24pt"}
**pq-size="24pt":** Custom Arbitrary Dimensions
:::
```

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

## Font Weights and Shapes

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

By default, pullquotes perfectly inherit the surrounding document's font style. You can override this using the style utilities.

```markdown
::: {.pullquote pq-style="italic"}
This paragraph is explicitly rendered in italics, overriding the inherited body text style.
:::
```

::: {.pullquote pq-style="italic"}
This paragraph is explicitly rendered in italics, overriding the inherited body text style.
:::

## Custom Fonts

Because pullquotes are designed to fit seamlessly into your existing layout, they automatically inherit your document's ambient font settings (such as the `mainfont` defined in your YAML `variables:` block). You do not need to configure anything specially for the filter. However, if you want a specific quote to visually break away from the body text, you can override it using the `pq-font` attribute.

You must pass the exact, literal font name you wish to use.

```markdown
::: {.pullquote pq-font="Georgia"}
This pullquote overrides the document defaults and explicitly uses the Georgia font.
:::
```

::: {.pullquote pq-font="Georgia"}
This pullquote overrides the document defaults and explicitly uses the Georgia font.
:::

> **No Font Validation:** The filter passes this name directly to the typesetting engine without checking if the font is actually available. If the font is unavailable, LaTeX's `fontspec` will halt with a compile error, Typst will substitute a fallback issuing a warning, and HTML browsers will silently revert to their default system fonts.

## Colors

This section describes how to apply colors to the pullquote text and its decorative left border. The filter normalizes color inputs to ensure they render identically across LaTeX, Typst, and HTML.

### Basic Color Attributes

Use `pq-text-color` for the text, and `pq-bar-color` for the left border.

```markdown
::: {.pullquote pq-text-color="CadetBlue" pq-bar-color="Thistle"}
This quote uses the SVG named color **CadetBlue** for text and the pastel **Thistle** for the border.
:::
```

::: {.pullquote pq-text-color="CadetBlue" pq-bar-color="Thistle"}
This quote uses the SVG named color **CadetBlue** for text and the pastel **Thistle** for the border.
:::

### Hex Codes

The filter fully supports 6-character hex codes and 3-character shorthands.

```markdown
::: {.pullquote pq-text-color="#827397" pq-bar-color="#FAA"}
This quote uses raw Hex codes: **#827397** for text and the shorthand **#FAA** (Soft Coral) for the bar.
:::
```

::: {.pullquote pq-text-color="#827397" pq-bar-color="#FAA"}
This quote uses raw Hex codes: **#827397** for text and the shorthand **#FAA** (Soft Coral) for the bar.
:::

### Color Mixing

The extension supports LaTeX’s `xcolor` percentage-mixing syntax. This maps reliably across Typst, LaTeX, and HTML (which leverages the native CSS `color-mix()` function).

```markdown
::: {.pullquote pq-text-color="Indigo!90!Black" pq-bar-color="Indigo!20"}
This quote uses a three-part blend for the text (**Indigo mixed at 90% with Black**) and a standard two-part blend with white for the bar.
:::
```

::: {.pullquote pq-text-color="Indigo!90!Black" pq-bar-color="Indigo!20"}
This quote uses a three-part blend for the text (**Indigo mixed at 90% with Black**) and a standard two-part blend with white for the bar.
:::

## Box Padding and Borders

The `pq-padding-left` attribute controls the gap between the bar and the quote text, independent of the bar's own thickness (`pq-bar-width`).

```markdown
::: {.pullquote pq-bar-width="0.5em" pq-padding-left="1.5em"}
This quote widens the gap between the bar and the text using **pq-padding-left="1.5em"**, independent of the 0.5em bar thickness.
:::
```

::: {.pullquote pq-bar-width="0.5em" pq-padding-left="1.5em"}
This quote widens the gap between the bar and the text using **pq-padding-left="1.5em"**, independent of the 0.5em bar thickness.
:::

The remaining three sides — `pq-padding-right`, `pq-padding-top`, and `pq-padding-bottom` — can each be tuned independently of `pq-padding-left`, giving full control over the box's inner spacing.

```markdown
::: {.pullquote pq-bar-color="SeaGreen" pq-padding-left="1em" pq-padding-right="1em" pq-padding-top="1em" pq-padding-bottom="1em"}
This quote sets an even 1em of padding on every side, giving the text room to breathe on all edges rather than just next to the bar.
:::
```

::: {.pullquote pq-bar-color="SeaGreen" pq-padding-left="1em" pq-padding-right="1em" pq-padding-top="1em" pq-padding-bottom="1em"}
This quote sets an even 1em of padding on every side, giving the text room to breathe on all edges rather than just next to the bar.
:::

## Block-Level Positioning and Width

By adjusting `pq-width` and `pq-box-align`, you can set the width of the pullquote and position the entire block to the left, center, or right of the page.

```markdown
::: {.pullquote pq-width="45%" pq-box-align="right"}
This quote takes up 45% of the page width and is aligned flush to the right margin.
:::
```

::: {.pullquote pq-width="45%" pq-box-align="right"}
This quote takes up 45% of the page width and is aligned flush to the right margin.
:::

Absolute units such as `pq-width="300pt"` or `pq-width="10cm"` are also fully supported.

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

The `pq-skip` attribute allows you to adjust the vertical space between lines of text. To guarantee identical layouts across all three formatting engines, it uses a semantic dictionary rather than raw units.

```markdown
::: {.pullquote pq-size="xl" pq-skip="loose"}
This quote uses a `pq-skip` value of `loose`, acting as a double-spacing multiplier to let the text breathe.
:::
```

::: {.pullquote pq-size="xl" pq-skip="loose"}
This quote uses a `pq-skip` value of `loose`, acting as a double-spacing multiplier to let the text breathe.
:::

Tightening works the same way by using the `tight` keyword:

```markdown
::: {.pullquote pq-size="l" pq-skip="tight"}
This quote is deliberately set to `tight`, making it ideal for dense, heavily styled multi-line blocks.
:::
```

::: {.pullquote pq-size="l" pq-skip="tight"}
This quote is deliberately set to `tight`, making it ideal for dense, heavily styled multi-line blocks.
:::

## Global Metadata Configuration

You can establish project-wide defaults for your pullquotes using YAML frontmatter or a Pandoc defaults file. The filter checks for inline attributes first; if none exist, it falls back to the global metadata.

For example, if your document includes the following YAML frontmatter:

```yaml
---
pq-text-color: "DarkSlateGray"
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

::: {.pullquote pq-text-color="DarkSlateGray" pq-bar-color="CadetBlue" pq-width="80%" pq-size="l" pq-box-align="center"}
This quote has no inline attributes. It inherits its styling entirely from the YAML frontmatter defined at the top of this document (Centered, 80% width, Large size, DarkSlateGray text, CadetBlue bar).
:::

## Combining Multiple Attributes

Every key composes independently to create highly customized layouts:

```markdown
::: {.pullquote pq-font="Georgia" pq-style="italic" pq-size="xl" pq-width="80%" pq-box-align="center" pq-text-color="DarkSlateGray" pq-bar-color="SteelBlue" pq-bar-width="4px" pq-padding-left="1.5rem" pq-skip="relaxed"}
"Typography is the detail and the presentation of a story. It represents the voice of an atmosphere, or historical setting of some kind. It can do a lot of things."

— Cyrus Highsmith
:::
```

::: {.pullquote pq-font="Georgia" pq-style="italic" pq-size="xl" pq-width="80%" pq-box-align="center" pq-text-color="DarkSlateGray" pq-bar-color="SteelBlue" pq-bar-width="4px" pq-padding-left="1.5rem" pq-skip="relaxed"}
"Typography is the detail and the presentation of a story. It represents the voice of an atmosphere, or historical setting of some kind. It can do a lot of things."

— Cyrus Highsmith
:::
