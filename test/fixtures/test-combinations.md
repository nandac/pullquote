---
title: "Pullquote Test: Combinations and Edge Cases"
---

## The Default Pullquote

This test checks that if a user provides absolutely no arguments, the fallback defaults (80% width, dark gray text, light gray bar, italicized large text, centered box) trigger correctly.

```markdown
::: {.pullquote}
"Typography is the craft of endowing human language with a durable visual form."
--- Robert Bringhurst
:::
```

::: {.pullquote}
"Typography is the craft of endowing human language with a durable visual form."
--- Robert Bringhurst
:::

Here is some standard body text following the quote to ensure vertical spacing (`skip` and `margins`) is rendering gracefully without colliding with the surrounding paragraphs.

## The Extreme Stress Test

Finally, we combine everything: custom width, extreme size, custom colors, custom alignments, and multiple font styles in a single fenced Div.

```markdown
::: {.pullquote .pq-weight-bold .pq-family-serif .pq-style-upright size="pq-size-3xl" align="pq-align-center" boxalign="pq-box-center" width="95%" color="DarkGoldenrod" barcolor="MidnightBlue" barwidth="12px"}
THE ULTIMATE TEST
:::
```

::: {.pullquote .pq-weight-bold .pq-family-serif .pq-style-upright size="pq-size-3xl" align="pq-align-center" boxalign="pq-box-center" width="95%" color="DarkGoldenrod" barcolor="MidnightBlue" barwidth="12px"}
THE ULTIMATE TEST
:::
