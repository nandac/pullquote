---
pq-barcolor: CadetBlue
pq-boxalign: pq-box-center
pq-color: DarkSlateGray
pq-size: pq-size-l
pq-width: 80%
title: Demonstration of the Pullquote Filter for Pandoc
---

## Introduction

This document showcases the features of the `pullquote` Pandoc Lua
filter. Each example displays the required Markdown syntax alongside its
rendered output, ensuring visually identical layouts across LaTeX (PDF),
Typst (PDF), and HTML formats.

**Backend Note:** Typst and HTML outputs are fully standalone. For LaTeX
output, you must include the provided `pullquote.tex` file in your
document's preamble. You can do this by passing
`--include-in-header=pullquote.tex` to your Pandoc command or by
referencing it in your document's YAML metadata.

The extension leverages Pandoc's `fenced_divs` extension. If this is
disabled, the filter will issue a terminal warning and render the
elements as raw text instead of applying the styles.

## Fenced Divs Invocations

This filter follows Pandoc's standard conventions for container-based
styling. Because pullquotes are inherently block-level elements, they
are invoked exclusively using Fenced Divs with the `.pullquote` class.

``` markdown
::: {.pullquote}
"Typography is the craft of endowing human language with a durable visual form."
--- Robert Bringhurst
:::
```

::: pullquote
"Typography is the craft of endowing human language with a durable
visual form." --- Robert Bringhurst
:::

## Font Sizing

The extension provides a sizing scale to adjust the text relative to the
document's base font size. While the filter supports a full 9-step scale
for API consistency, the larger sizes below are the most practical for
pullquotes. If omitted, it defaults to the `pq-size-l` (large) scale.

**Rendered Sizing Scale:**

::: {.pullquote size="pq-size-normal"}
**pq-size-normal:** Best for longer, multi-sentence blockquotes.
:::

::: {.pullquote size="pq-size-l"}
**pq-size-l:** Large (The Default Size)
:::

::: {.pullquote size="pq-size-xl"}
**pq-size-xl:** Extra Large
:::

::: {.pullquote size="pq-size-2xl"}
**pq-size-2xl:** Extra Extra Large
:::

::: {.pullquote size="pq-size-3xl"}
**pq-size-3xl:** Extra Extra Extra Large
:::

## Font Weights, Shapes, and Families

The extension provides predefined typographic utility classes. These
styles are mapped to equivalent rendering properties across all formats
to ensure consistent output, regardless of the underlying engine.

### Font Weights

``` markdown
::: {.pullquote .pq-weight-bold}
This paragraph is in bold weight.
:::
```

::: {.pullquote .pq-weight-bold}
This paragraph is in bold weight.
:::

### Font Styles

By default, pullquotes render in italics. You can override this using
the style utilities.

``` markdown
::: {.pullquote .pq-style-upright}
This paragraph is explicitly rendered upright (non-italicized).
:::
```

::: {.pullquote .pq-style-upright}
This paragraph is explicitly rendered upright (non-italicized).
:::

### Font Families

``` markdown
::: {.pullquote .pq-family-sans}
This paragraph is in sans-serif.
:::
```

::: {.pullquote .pq-family-sans}
This paragraph is in sans-serif.
:::

## Colors and Borders

This section describes how to apply colors to the pullquote text and its
decorative left border. The filter normalizes color inputs to ensure
they render identically across LaTeX, Typst, and HTML.

### Basic Color Attributes

Use `color` for the text, `barcolor` for the left border, and `barwidth`
to adjust the border's thickness.

``` markdown
::: {.pullquote color="CadetBlue" barcolor="Thistle" barwidth="8px"}
This quote uses the SVG named color **CadetBlue** for text and the pastel **Thistle** for a thick 8px border.
:::
```

::: {.pullquote color="CadetBlue" barcolor="Thistle" barwidth="8px"}
This quote uses the SVG named color **CadetBlue** for text and the
pastel **Thistle** for a thick 8px border.
:::

### Hex Codes

The filter fully supports 6-character hex codes and 3-character
shorthands.

``` markdown
::: {.pullquote color="#827397" barcolor="#F00"}
This quote uses raw Hex codes: **#827397** for text and the shorthand **#F00** (Red) for the bar.
:::
```

::: {.pullquote color="#827397" barcolor="#F00"}
This quote uses raw Hex codes: **#827397** for text and the shorthand
**#F00** (Red) for the bar.
:::

### Color Mixing

The extension supports LaTeX's `xcolor` percentage-mixing syntax. This
maps reliably across Typst, LaTeX, and HTML (which leverages the native
CSS `color-mix()` function).

``` markdown
::: {.pullquote color="Indigo!90!Black" barcolor="Indigo!20" barwidth="6px"}
This quote uses a three-part blend for the text (**Indigo mixed at 90% with Black**) and a standard two-part blend with white for the bar.
:::
```

::: {.pullquote color="Indigo!90!Black" barcolor="Indigo!20" barwidth="6px"}
This quote uses a three-part blend for the text (**Indigo mixed at 90%
with Black**) and a standard two-part blend with white for the bar.
:::

## Block-Level Positioning and Width

By adjusting `width` and `boxalign`, we can position the entire
pullquote block to the left, center, or right of the page. This shifts
the block within the standard document flow; the body text will sit
above and below it rather than wrapping around it.

``` markdown
::: {.pullquote width="45%" boxalign="pq-box-right"}
This quote takes up 45% of the page width and is aligned flush to the right margin.
:::
```

::: {.pullquote width="45%" boxalign="pq-box-right"}
This quote takes up 45% of the page width and is aligned flush to the
right margin.
:::

*(Absolute units such as `width="300pt"` or `width="10cm"` are also
fully supported).*

## Inner Text Alignment

The `align` attribute controls text alignment *within* the Fenced Div.

``` markdown
::: {.pullquote align="pq-align-center" width="70%" boxalign="pq-box-left"}
This quote takes up 70% of the page and is aligned to the left margin, but the text *inside* the box is centered.
:::
```

::: {.pullquote align="pq-align-center" width="70%" boxalign="pq-box-left"}
This quote takes up 70% of the page and is aligned to the left margin,
but the text *inside* the box is centered.
:::

## Global Metadata Configuration

You can establish project-wide defaults for your pullquotes using YAML
frontmatter or a Pandoc defaults file. The filter checks for inline
attributes first; if none exist, it falls back to the global metadata.

For example, if your document includes the following YAML frontmatter:

``` yaml
---
pq-color: "DarkSlateGray"
pq-barcolor: "CadetBlue"
pq-width: "80%"
pq-size: "pq-size-l"
pq-boxalign: "pq-box-center"
---
```

A pullquote with no inline attributes will automatically inherit those
exact styles:

``` markdown
::: {.pullquote}
This quote has no inline attributes. It inherits its styling entirely from the YAML frontmatter defined at the top of this document.
:::
```

::: pullquote
This quote has no inline attributes. It inherits its styling entirely
from the YAML frontmatter defined at the top of this document (Centered,
80% width, Large size, DarkSlateGray text, CadetBlue bar).
:::

## Combining Multiple Classes and Attributes

Multiple typographic utilities and attributes can be combined within the
same element. Font, size, color, and alignment compose independently.

``` markdown
::: {.pullquote .pq-weight-bold .pq-family-serif .pq-style-smallcaps size="pq-size-3xl" align="pq-align-center" boxalign="pq-box-center" width="95%" color="DarkGoldenrod" barcolor="MidnightBlue" barwidth="12px" skip="2.0"}
The Ultimate Stress Test
:::
```

::: {.pullquote .pq-weight-bold .pq-family-serif .pq-style-smallcaps size="pq-size-3xl" align="pq-align-center" boxalign="pq-box-center" width="95%" color="DarkGoldenrod" barcolor="MidnightBlue" barwidth="12px" skip="2.0"}
The Ultimate Stress Test
:::
