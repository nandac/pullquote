---
title: "Pullquote Test: Box Alignment and Width"
---

## Block-Level Positioning

By adjusting `width` and `boxalign`, we can position the entire pullquote block to the left, center, or right of the page. Note that this shifts the block within the standard document flow; the body text will sit above and below it rather than wrapping around it.

```markdown
::: {.pullquote width="45%" boxalign="pq-box-right"}
This quote takes up 45% of the page width and is aligned flush to the right margin.
:::
```

::: {.pullquote width="45%" boxalign="pq-box-right"}
This quote takes up 45% of the page width and is aligned flush to the right margin.
:::

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum.

```markdown
::: {.pullquote width="60%" boxalign="pq-box-left" align="pq-align-center"}
This one takes up 60% and is aligned to the left margin, but the text *inside* it is centered. By adding a bit more length to this sentence, it will naturally wrap across multiple lines, making the ragged edges on both sides visually obvious.
:::
```

::: {.pullquote width="60%" boxalign="pq-box-left" align="pq-align-center"}
This one takes up 60% and is aligned to the left margin, but the text *inside* it is centered. By adding a bit more length to this sentence, it will naturally wrap across multiple lines, making the ragged edges on both sides visually obvious.
:::

Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. Nullam varius, turpis et commodo pharetra, est eros bibendum elit, nec luctus magna felis sollicitudin mauris. Integer in mauris eu nibh euismod gravida.

## Absolute Width Units

This tests using absolute measurement units (like `pt` or `cm`) instead of percentages to ensure the filter passes the specific unit directly to the engines.

```markdown
::: {.pullquote width="300pt" boxalign="pq-box-center"}
This quote uses an absolute width of **300pt** rather than a percentage. The filter should pass this absolute unit through to LaTeX, Typst, and HTML without applying the percentage-to-linewidth math.
:::
```

::: {.pullquote width="300pt" boxalign="pq-box-center"}
This quote uses an absolute width of **300pt** rather than a percentage. The filter should pass this absolute unit through to LaTeX, Typst, and HTML without applying the percentage-to-linewidth math.
:::
