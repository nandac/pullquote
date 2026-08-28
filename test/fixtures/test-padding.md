---
title: "Pullquote Test: Padding"
---

## Default Padding

This tests the default spacing on each side of the box when no padding attributes are specified (`pq-padding-left` defaults to `1em`/`12pt`; `pq-padding-top`/`pq-padding-bottom` default to `0.25em`/`4pt`; `pq-padding-right` defaults to `0`). HTML padding defaults deliberately use `em` rather than a fixed `px` value, so the gap around the text scales with whichever `pq-size` the pullquote itself uses.

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

## Padding with Multi-Paragraph Content

This tests that padding is applied once to the outer edges of the box, not per paragraph, when a pullquote contains multiple paragraphs of body text.

```markdown
::: {.pullquote pq-padding-left="20px" pq-padding-right="20px" pq-padding-top="16px" pq-padding-bottom="16px"}
This is the first paragraph inside a multi-paragraph pullquote. The configured padding should apply once, at the outer edges of the whole box.

This is a second paragraph in the same pullquote. There should be normal paragraph spacing between it and the paragraph above, without any extra padding applied around each individual paragraph.

A third paragraph confirms the bar and box padding both span the full height of the block, not just the first paragraph.
:::
```

::: {.pullquote pq-padding-left="20px" pq-padding-right="20px" pq-padding-top="16px" pq-padding-bottom="16px"}
This is the first paragraph inside a multi-paragraph pullquote. The configured padding should apply once, at the outer edges of the whole box.

This is a second paragraph in the same pullquote. There should be normal paragraph spacing between it and the paragraph above, without any extra padding applied around each individual paragraph.

A third paragraph confirms the bar and box padding both span the full height of the block, not just the first paragraph.
:::
