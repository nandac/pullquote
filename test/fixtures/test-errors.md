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

## 3. Missing Typst Sans-Serif Font (Warning)

This tests that Typst output warns when a pullquote uses `pq-family="sans"` and no `sansfont` is configured in metadata, falling back to a best-effort font chain instead of crashing. This warning only fires for Typst output, since Typst is the only one of the three engines with no bundled sans-serif font.

```markdown
::: {.pullquote pq-family="sans"}
This should fall back to the best-effort sans-serif chain for Typst output.
:::
```

::: {.pullquote pq-family="sans"}
This should fall back to the best-effort sans-serif chain for Typst output.
:::

## 4. Invalid pq-skip, pq-size, and Malformed Color-Mix Syntax (Warnings)

This quote passes a non-numeric, non-dimension `pq-skip`, a zero `pq-size`, and a malformed color-mix string. The filter should log a warning for each and fall back to its default, but it should NOT crash.

```markdown
::: {.pullquote pq-skip="normal" pq-size="0px" pq-text-color="red!!blue"}
This should fall back to the default skip, size, and text color.
:::
```

::: {.pullquote pq-skip="normal" pq-size="0px" pq-text-color="red!!blue"}
This should fall back to the default skip, size, and text color.
:::

## 5. Invalid Colors (Fatal Error)

This tests the `abort()` trigger. Passing an undefined color string that isn't a Hex code or in the CSS/Typst dictionary should instantly halt compilation to prevent generating a corrupted PDF or HTML file — the same way for HTML, LaTeX, and Typst, since this filter has no per-format color vocabulary.

```markdown
::: {.pullquote pq-text-color="MadeUpPurple"}
This text will never render because the filter will crash first.
:::
```

::: {.pullquote pq-text-color="MadeUpPurple"}
This text will never render because the filter will crash first.
:::
