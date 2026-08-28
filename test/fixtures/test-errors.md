---
title: "Pullquote Test: Error Handling"
---

## 1. Invalid Taxonomy Keys (Warnings)

This quote passes fake classes. The filter should log warnings for the unknown size, alignment, and box alignment, but it should NOT crash. It will strip the bad keys and fall back to the default styling for those attributes.

```markdown
::: {.pullquote pq-size="pq-size-fake" pq-text-align="pq-align-upsidedown" pq-box-align="pq-box-nowhere"}
This should fall back to default sizing and alignment.
:::
```

::: {.pullquote pq-size="pq-size-fake" pq-text-align="pq-align-upsidedown" pq-box-align="pq-box-nowhere"}
This should fall back to default sizing and alignment.
:::

## 2. Invalid Dimension & Unit Values (Warnings)

This quote passes malformed dimension and unit values. The filter should log warnings for each invalid attribute and fall back to its default, but it should NOT crash.

```markdown
::: {.pullquote pq-width="abc%" pq-bar-width="banana" pq-padding-left="orange" pq-padding-right="grape" pq-padding-top="mango" pq-padding-bottom="kiwi" pq-html-unit="bogus"}
This should fall back to the default width, bar width, padding on every side, and HTML unit.
:::
```

::: {.pullquote pq-width="abc%" pq-bar-width="banana" pq-padding-left="orange" pq-padding-right="grape" pq-padding-top="mango" pq-padding-bottom="kiwi" pq-html-unit="bogus"}
This should fall back to the default width, bar width, padding on every side, and HTML unit.
:::

## 3. Invalid Colors (Fatal Error)

This tests the `abort()` trigger. Passing an undefined color string that isn't a Hex code or in the CSS/Typst dictionary should instantly halt compilation to prevent generating a corrupted PDF or HTML file.

```markdown
::: {.pullquote pq-color="MadeUpPurple"}
This text will never render because the filter will crash first.
:::
```

::: {.pullquote pq-color="MadeUpPurple"}
This text will never render because the filter will crash first.
:::
