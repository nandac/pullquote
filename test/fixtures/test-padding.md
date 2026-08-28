---
title: "Pullquote Test: Padding"
---

## Default Padding

This tests the default spacing on each side of the box when no padding attributes are specified (`pq-padding-left` defaults to `1rem`/`12pt`; `pq-padding-top`/`pq-padding-bottom` default to `4px`/`4pt`; `pq-padding-right` defaults to `0`).

```markdown
::: {.pullquote}
This pullquote uses the default padding on every side.
:::
```

::: {.pullquote}
This pullquote uses the default padding on every side.
:::

## Custom Left Padding (Pixels)

This tests overriding the left padding using an absolute `px` value, which the filter converts to `pt` for the LaTeX and Typst pathways.

```markdown
::: {.pullquote pq-padding-left="24px"}
This pullquote has a much wider gap between the bar and the text.
:::
```

::: {.pullquote pq-padding-left="24px"}
This pullquote has a much wider gap between the bar and the text.
:::

## Custom Left Padding (Points)

This tests overriding the left padding using an absolute `pt` value directly, primarily relevant for LaTeX and Typst PDF output.

```markdown
::: {.pullquote pq-padding-left="6pt"}
This pullquote has a tighter gap between the bar and the text.
:::
```

::: {.pullquote pq-padding-left="6pt"}
This pullquote has a tighter gap between the bar and the text.
:::

## Independent Padding on Every Side

This tests setting `pq-padding-right`, `pq-padding-top`, and `pq-padding-bottom` independently of `pq-padding-left`, confirming each side can be tuned separately.

```markdown
::: {.pullquote pq-padding-left="12px" pq-padding-right="24px" pq-padding-top="16px" pq-padding-bottom="16px"}
This pullquote has a different padding value set on all four sides of the box.
:::
```

::: {.pullquote pq-padding-left="12px" pq-padding-right="24px" pq-padding-top="16px" pq-padding-bottom="16px"}
This pullquote has a different padding value set on all four sides of the box.
:::
