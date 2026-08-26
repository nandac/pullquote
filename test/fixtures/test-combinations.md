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

## Vertical Spacing (Skip)

This tests the `skip` attribute which manipulates line-height (leading) across the different engines.

```markdown
::: {.pullquote pq-skip="2.5"}
This quote has a highly exaggerated skip value of 2.5 applied to it. When this text wraps across multiple lines, you should clearly see a massive amount of vertical space between each line of text, proving the filter handles line-height correctly.
:::
```

::: {.pullquote pq-skip="2.5"}
This quote has a highly exaggerated skip value of 2.5 applied to it. When this text wraps across multiple lines, you should clearly see a massive amount of vertical space between each line of text, proving the filter handles line-height correctly.
:::

## The Extreme Stress Test

Finally, we combine everything: custom width, extreme size, custom colors, custom alignments, and multiple font styles in a single fenced Div.

```markdown
::: {.pullquote pq-weight="bold" pq-family="serif" pq-style="upright" pq-size="3xl" pq-text-align="center" pq-box-align="center" pq-width="95%" pq-color="DarkGoldenrod" pq-bar-color="MidnightBlue" pq-bar-width="12px"}
THE ULTIMATE TEST
:::
```

::: {.pullquote pq-weight="bold" pq-family="serif" pq-style="upright" pq-size="3xl" pq-text-align="center" pq-box-align="center" pq-width="95%" pq-color="DarkGoldenrod" pq-bar-color="MidnightBlue" pq-bar-width="12px"}
THE ULTIMATE TEST
:::
