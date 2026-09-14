---
title: "Pullquote Test: Error Handling"
---

Unlike every other fixture, this one is not built into a preview and has no AST snapshot — the `Makefile` filters it out of `TEST_NAMES`. It is driven by the `test-errors` target, which runs it through the filter and greps *stderr*, so what is under test is the diagnostic text rather than the rendered result. Each section below should produce a warning and fall back to a default; only the last one is meant to abort. Adding or removing a pullquote here changes the expected warning counts, so the target must be updated alongside it.

## Invalid Taxonomy Keys (Warnings)

This quote passes fake classes. The filter should log warnings for the unknown size, alignment, and box alignment, but it should NOT crash. It will strip the bad keys and fall back to the default styling for those attributes.

```markdown
::: {.pullquote pq-size="pq-size-fake" pq-text-align="pq-align-upsidedown" pq-box-align="pq-box-nowhere"}
This should fall back to default sizing and alignment.
:::
```

::: {.pullquote pq-size="pq-size-fake" pq-text-align="pq-align-upsidedown" pq-box-align="pq-box-nowhere"}
This should fall back to default sizing and alignment.
:::

## Invalid Dimension & Unit Values (Warnings)

This quote passes malformed dimension and unit values. The filter should log warnings for each invalid attribute and fall back to its default, but it should NOT crash.

```markdown
::: {.pullquote pq-width="abc%" pq-bar-width="banana" pq-padding-left="orange" pq-padding-right="grape" pq-padding-top="mango" pq-padding-bottom="kiwi" pq-html-unit="bogus"}
This should fall back to the default width, bar width, padding on every side, and HTML unit.
:::
```

::: {.pullquote pq-width="abc%" pq-bar-width="banana" pq-padding-left="orange" pq-padding-right="grape" pq-padding-top="mango" pq-padding-bottom="kiwi" pq-html-unit="bogus"}
This should fall back to the default width, bar width, padding on every side, and HTML unit.
:::

## Invalid pq-skip, Obsolete pq-size, and Malformed Color-Mix Syntax (Warnings)

This quote passes a non-numeric, non-dimension `pq-skip`, an obsolete `pq-size` (`3xl`), and a malformed color-mix string. The filter should log a warning for each and fall back to its default, but it should NOT crash.

```markdown
::: {.pullquote pq-skip="normal" pq-size="3xl" pq-text-color="red!!blue"}
This should fall back to the default skip, size, and text color.
:::
```

::: {.pullquote pq-skip="normal" pq-size="3xl" pq-text-color="red!!blue"}
This should fall back to the default skip, size, and text color.
:::

## Invalid Colors (Fatal Error)

This tests the `abort()` trigger. Passing an undefined color string that isn't a Hex code or in the CSS/Typst dictionary should instantly halt compilation to prevent generating a corrupted PDF or HTML file — the same way for HTML, LaTeX, and Typst, since this filter has no per-format color vocabulary.

```markdown
::: {.pullquote pq-text-color="MadeUpPurple"}
This text will never render because the filter will crash first.
:::
```

::: {.pullquote pq-text-color="MadeUpPurple"}
This text will never render because the filter will crash first.
:::
