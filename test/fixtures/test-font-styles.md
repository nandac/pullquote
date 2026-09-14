---
title: "Pullquote Test: Typography Styles"
---

`pq-weight`, `pq-font` and `pq-style` are three independent axes that compose into a single font selection. Each engine applies them in its own way — CSS declarations, LaTeX font-shape commands inside the `size=` key, and Typst `#set text` rules — so this fixture is mostly a check that all three axes survive being combined. Compare the three rendered previews: by default, pullquotes seamlessly inherit the document's configured fonts. Using `pq-font` allows overriding this inheritance with a literal custom font name.

## Weights, Fonts, and Variants

This tests the CSS-like class injection for font weights, fonts, and styles without disrupting the component layout.

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

### Custom Fonts

```markdown
::: {.pullquote}
This is an un-styled quote, which naturally inherits the document's font.
:::
```

::: {.pullquote}
This is an un-styled quote, which naturally inherits the document's font.
:::

```markdown
::: {.pullquote pq-font="Georgia"}
This is a quote using a literal custom font name.
:::
```

::: {.pullquote pq-font="Georgia"}
This is a quote using a literal custom font name.
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

### Combinations

```markdown
::: {.pullquote pq-style="smallcaps" pq-weight="bold" pq-font="Georgia"}
This is a Bold, Small-Caps quote using Georgia.
:::
```

::: {.pullquote pq-style="smallcaps" pq-weight="bold" pq-font="Georgia"}
This is a Bold, Small-Caps quote using Georgia.
:::

```markdown
::: {.pullquote pq-style="upright" pq-weight="medium" pq-font="Noto Sans"}
This is a Medium-weight, Upright quote using Noto Sans.
:::
```

::: {.pullquote pq-style="upright" pq-weight="medium" pq-font="Noto Sans"}
This is a Medium-weight, Upright quote using Noto Sans.
:::
