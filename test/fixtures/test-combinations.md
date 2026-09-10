---
title: "Pullquote Test: Combinations and Edge Cases"
---

This fixture is the integration check: bare defaults at one end, every attribute at once at the other. The individual attributes each have their own focused fixture; what is being tested here is that they compose without interfering. Compare the three rendered previews — the fully-loaded quote at the end is the one most likely to expose an ordering bug in a single engine, since it exercises width, size, colors, both alignments, all three font axes, padding and spacing simultaneously.

## The Default Pullquote

This test checks that if a user provides absolutely no arguments, the fallback defaults trigger correctly: 80% width, `#888888` text, a `#d9d9d9` bar, italicized large text, and a centered box. All three engines resolve these to the same values, so the default quote should look the same in every preview.

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

This tests `pq-skip`, which sets the baseline-to-baseline line spacing as a multiple of the pullquote's own font size. The dedicated `test-skip.md` fixture covers the full range and the unit forms; this one only confirms that an extreme value still composes with everything else. All three engines should produce the same spacing.

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
::: {.pullquote pq-weight="bold" pq-family="serif" pq-style="slanted" pq-size="3xl" pq-text-align="center" pq-box-align="center" pq-width="95%" pq-text-color="DarkSlateBlue" pq-bar-color="PowderBlue" pq-bar-width="12px" pq-padding-left="20px" pq-skip="2.0"}
THE ULTIMATE TEST
:::
```

::: {.pullquote pq-weight="bold" pq-family="serif" pq-style="slanted" pq-size="3xl" pq-text-align="center" pq-box-align="center" pq-width="95%" pq-text-color="DarkSlateBlue" pq-bar-color="PowderBlue" pq-bar-width="12px" pq-padding-left="20px" pq-skip="2.0"}
THE ULTIMATE TEST
:::
