---
title: "Pullquote Test: Typography Styles"
---

## Weights, Families, and Variants

This tests the CSS-like class injection for font weights, families, and styles without disrupting the component layout.

```markdown
::: {.pullquote .pq-weight-bold .pq-family-sans}
This is a Bold, Sans-Serif quote using the default size.
:::
```

::: {.pullquote .pq-weight-bold .pq-family-sans}
This is a Bold, Sans-Serif quote using the default size.
:::

```markdown
::: {.pullquote .pq-family-mono}
This is a Monospace quote.
:::
```

::: {.pullquote .pq-family-mono}
This is a Monospace quote.
:::

```markdown
::: {.pullquote .pq-style-smallcaps .pq-weight-bold}
This is a Bold, Small-Caps quote.
:::
```

::: {.pullquote .pq-style-smallcaps .pq-weight-bold}
This is a Bold, Small-Caps quote.
:::

```markdown
::: {.pullquote .pq-style-upright .pq-weight-medium}
This is a Medium-weight, Upright (non-italicized) quote.
:::
```

::: {.pullquote .pq-style-upright .pq-weight-medium}
This is a Medium-weight, Upright (non-italicized) quote.
:::
