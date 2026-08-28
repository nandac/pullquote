---
title: "Pullquote Test: HTML Sizing Unit"
---

## Default Unit (`rem`)

This tests the default `pq-html-unit`, which scales the `pq-size` keys using root-relative `rem` units for HTML output. LaTeX and Typst are unaffected by this attribute, since it only controls CSS output.

```markdown
::: {.pullquote pq-size="l"}
This quote scales using the default rem unit.
:::
```

::: {.pullquote pq-size="l"}
This quote scales using the default rem unit.
:::

## Explicit `em` Unit

This tests overriding `pq-html-unit` to `em`, useful for frameworks that scale typography via cascading `em` units rather than off the document root.

```markdown
::: {.pullquote pq-size="l" pq-html-unit="em"}
This quote scales using em units instead of rem.
:::
```

::: {.pullquote pq-size="l" pq-html-unit="em"}
This quote scales using em units instead of rem.
:::

## Custom Dimensions Are Unaffected

This tests that `pq-html-unit` only applies to the standard scale keys (`3xs` through `3xl`). A custom dimension passed directly to `pq-size` is used as-is and ignores `pq-html-unit` entirely.

```markdown
::: {.pullquote pq-size="2rem" pq-html-unit="em"}
This quote uses a custom 2rem size, unaffected by the em unit setting above.
:::
```

::: {.pullquote pq-size="2rem" pq-html-unit="em"}
This quote uses a custom 2rem size, unaffected by the em unit setting above.
:::
