---
title: "Pullquote Test: Error Handling"
---

## 1. Invalid Taxonomy Keys (Warnings)

This quote passes fake classes. The filter should log warnings for the unknown size, alignment, and box alignment, but it should NOT crash. It will strip the bad keys and fall back to the default styling for those attributes.

```markdown
::: {.pullquote size="pq-size-fake" align="pq-align-upsidedown" boxalign="pq-box-nowhere"}
This should fall back to default sizing and alignment.
:::
```

::: {.pullquote size="pq-size-fake" align="pq-align-upsidedown" boxalign="pq-box-nowhere"}
This should fall back to default sizing and alignment.
:::

## 2. Invalid Colors (Fatal Error)

This tests the `abort()` trigger. Passing an undefined color string that isn't a Hex code or in the CSS/Typst dictionary should instantly halt compilation to prevent generating a corrupted PDF or HTML file.

```markdown
::: {.pullquote color="MadeUpPurple"}
This text will never render because the filter will crash first.
:::
```

::: {.pullquote color="MadeUpPurple"}
This text will never render because the filter will crash first.
:::
