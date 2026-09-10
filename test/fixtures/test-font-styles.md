---
title: "Pullquote Test: Typography Styles"
---

`pq-weight`, `pq-family` and `pq-style` are three independent axes that compose into a single font selection. Each engine applies them in its own way — CSS declarations, LaTeX font-shape commands inside the `size=` key, and Typst `#set text` rules — so this fixture is mostly a check that all three axes survive being combined. Compare the three rendered previews: `serif`/`sans`/`mono` resolve through the document's own `mainfont`/`sansfont`/`monofont`, so they only match across formats when those are configured identically, as `test/settings/shared.yaml` does. Typst is the one engine with no bundled sans-serif, so a document that asks for `sans` without configuring one falls back to a best-effort chain and warns.

## Weights, Families, and Variants

This tests the CSS-like class injection for font weights, families, and styles without disrupting the component layout.

### Font Weights

```markdown
::: {.pullquote pq-weight="normal"}
This is a Normal weight quote.
:::
```

::: {.pullquote pq-weight="normal"}
This is a Normal weight quote.
:::

```markdown
::: {.pullquote pq-weight="medium"}
This is a Medium-weight quote.
:::
```

::: {.pullquote pq-weight="medium"}
This is a Medium-weight quote.
:::

```markdown
::: {.pullquote pq-weight="bold"}
This is a Bold weight quote.
:::
```

::: {.pullquote pq-weight="bold"}
This is a Bold weight quote.
:::

### Font Families

```markdown
::: {.pullquote}
This is an un-styled quote, which should default pq-family to serif.
:::
```

::: {.pullquote}
This is an un-styled quote, which should default pq-family to serif.
:::

```markdown
::: {.pullquote pq-family="serif"}
This is a Serif quote.
:::
```

::: {.pullquote pq-family="serif"}
This is a Serif quote.
:::

```markdown
::: {.pullquote pq-family="sans"}
This is a Sans-Serif quote.
:::
```

::: {.pullquote pq-family="sans"}
This is a Sans-Serif quote.
:::

```markdown
::: {.pullquote pq-family="mono"}
This is a Monospace quote.
:::
```

::: {.pullquote pq-family="mono"}
This is a Monospace quote.
:::

```markdown
::: {.pullquote pq-family="Libre Baskerville"}
This is a quote using a literal custom font name, not one of serif/sans/mono.
:::
```

::: {.pullquote pq-family="Libre Baskerville"}
This is a quote using a literal custom font name, not one of serif/sans/mono.
:::

### Font Styles and Variants

```markdown
::: {.pullquote pq-style="upright"}
This is an Upright (non-italicized) quote.
:::
```

::: {.pullquote pq-style="upright"}
This is an Upright (non-italicized) quote.
:::

```markdown
::: {.pullquote pq-style="italic"}
This is an explicitly Italicized quote (which is the default).
:::
```

::: {.pullquote pq-style="italic"}
This is an explicitly Italicized quote (which is the default).
:::

```markdown
::: {.pullquote pq-style="emph"}
This is an Emphasized quote.
:::
```

::: {.pullquote pq-style="emph"}
This is an Emphasized quote.
:::

```markdown
::: {.pullquote pq-style="slanted"}
This is a Slanted (oblique) quote.
:::
```

::: {.pullquote pq-style="slanted"}
This is a Slanted (oblique) quote.
:::

```markdown
::: {.pullquote pq-style="smallcaps"}
This is a Small-Caps quote.
:::
```

::: {.pullquote pq-style="smallcaps"}
This is a Small-Caps quote.
:::

### 4. Combinations

```markdown
::: {.pullquote pq-style="smallcaps" pq-weight="bold" pq-family="serif"}
This is a Bold, Small-Caps, Serif quote.
:::
```

::: {.pullquote pq-style="smallcaps" pq-weight="bold" pq-family="serif"}
This is a Bold, Small-Caps, Serif quote.
:::

```markdown
::: {.pullquote pq-style="upright" pq-weight="medium" pq-family="sans"}
This is a Medium-weight, Upright, Sans-Serif quote.
:::
```

::: {.pullquote pq-style="upright" pq-weight="medium" pq-family="sans"}
This is a Medium-weight, Upright, Sans-Serif quote.
:::
