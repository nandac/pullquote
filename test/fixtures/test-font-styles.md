---
title: "Pullquote Test: Typography Styles"
---

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
