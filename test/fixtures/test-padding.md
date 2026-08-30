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

## Wide Left Padding

This tests a deliberately exaggerated `pq-padding-left` value, so the gap between the bar and the text is unmistakably wider than the default when comparing previews side by side.

```markdown
::: {.pullquote pq-padding-left="60px"}
This pullquote pushes the text far away from the bar with a 60px left padding — an extreme value chosen to make the difference from the default obvious at a glance.
:::
```

::: {.pullquote pq-padding-left="60px"}
This pullquote pushes the text far away from the bar with a 60px left padding — an extreme value chosen to make the difference from the default obvious at a glance.
:::

## Tight Left Padding

This tests a deliberately minimal `pq-padding-left` value, so the text sits almost flush against the bar — the opposite extreme from the previous example, and again clearly distinct from the default.

```markdown
::: {.pullquote pq-padding-left="2pt"}
This pullquote crowds the text right up against the bar with a 2pt left padding, the tightest gap the filter allows before the text and bar would visually merge.
:::
```

::: {.pullquote pq-padding-left="2pt"}
This pullquote crowds the text right up against the bar with a 2pt left padding, the tightest gap the filter allows before the text and bar would visually merge.
:::

## Independent Padding on Every Side

This tests setting `pq-padding-left`, `pq-padding-right`, `pq-padding-top`, and `pq-padding-bottom` to four deliberately mismatched values, so the box reads as visibly lopsided rather than evenly padded — confirming each side is tuned independently rather than sharing a single value.

```markdown
::: {.pullquote pq-padding-left="4px" pq-padding-right="60px" pq-padding-top="2px" pq-padding-bottom="40px"}
This pullquote is crowded against the bar and the top edge, but has generous room on the right and at the bottom — four different padding values, deliberately mismatched so the asymmetry is obvious.
:::
```

::: {.pullquote pq-padding-left="4px" pq-padding-right="60px" pq-padding-top="2px" pq-padding-bottom="40px"}
This pullquote is crowded against the bar and the top edge, but has generous room on the right and at the bottom — four different padding values, deliberately mismatched so the asymmetry is obvious.
:::

## Padding with Multi-Paragraph Content

This tests that padding is applied once to the outer edges of the box, not per paragraph, when a pullquote contains multiple paragraphs of body text. A generous, even padding is used so the outer margin is clearly visible around all three paragraphs.

```markdown
::: {.pullquote pq-padding-left="32px" pq-padding-right="32px" pq-padding-top="24px" pq-padding-bottom="24px"}
This is the first paragraph inside a multi-paragraph pullquote. The configured padding should apply once, at the outer edges of the whole box.

This is a second paragraph in the same pullquote. There should be normal paragraph spacing between it and the paragraph above, without any extra padding applied around each individual paragraph.

A third paragraph confirms the bar and box padding both span the full height of the block, not just the first paragraph.
:::
```

::: {.pullquote pq-padding-left="32px" pq-padding-right="32px" pq-padding-top="24px" pq-padding-bottom="24px"}
This is the first paragraph inside a multi-paragraph pullquote. The configured padding should apply once, at the outer edges of the whole box.

This is a second paragraph in the same pullquote. There should be normal paragraph spacing between it and the paragraph above, without any extra padding applied around each individual paragraph.

A third paragraph confirms the bar and box padding both span the full height of the block, not just the first paragraph.
:::
