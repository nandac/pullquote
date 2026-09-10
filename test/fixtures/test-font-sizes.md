---
title: "Pullquote Test: Font Sizes"
---

`pq-size` accepts either a key from the filter's own scale (`3xs` through `3xl`) or an exact dimension. The scale keys are mapped per engine — LaTeX gets its native size commands, HTML a `rem`/`em` multiplier, Typst an `em` value — so they are equivalent by construction rather than by arithmetic. Compare the three rendered previews: sizes should track each other across the whole scale, with `px` converted at the standard 96dpi ratio and `rem` resolved as `em` for the PDF engines. The exception is `vw`, which is genuinely viewport-relative and has no PDF equivalent; HTML resolves it against the window while LaTeX and Typst fall back to treating the number as `em`.

## Symmetrical Size Scale

This tests the size scale defined by the filter.

```markdown
::: {.pullquote pq-size="3xs"}
This is extra extra extra small.
:::
```

::: {.pullquote pq-size="3xs"}
This is extra extra extra small.
:::

```markdown
::: {.pullquote pq-size="2xs"}
This is extra extra small.
:::
```

::: {.pullquote pq-size="2xs"}
This is extra extra small.
:::

```markdown
::: {.pullquote pq-size="xs"}
This is extra small.
:::
```

::: {.pullquote pq-size="xs"}
This is extra small.
:::

```markdown
::: {.pullquote pq-size="s"}
This is small.
:::
```

::: {.pullquote pq-size="s"}
This is small.
:::

```markdown
::: {.pullquote pq-size="m"}
This is medium size (base document size).
:::
```

::: {.pullquote pq-size="m"}
This is medium size (base document size).
:::

```markdown
::: {.pullquote pq-size="l"}
This is large size (the default if no size is provided).
:::
```

::: {.pullquote pq-size="l"}
This is large size (the default if no size is provided).
:::

```markdown
::: {.pullquote pq-size="xl"}
This is extra large size.
:::
```

::: {.pullquote pq-size="xl"}
This is extra large size.
:::

```markdown
::: {.pullquote pq-size="2xl"}
This is extra extra large size.
:::
```

::: {.pullquote pq-size="2xl"}
This is extra extra large size.
:::

```markdown
::: {.pullquote pq-size="3xl"}
This is extra extra extra large size.
:::
```

::: {.pullquote pq-size="3xl"}
This is extra extra extra large size.
:::

## Custom Sizes

This tests setting the size to a custom value of the user's choosing.

```markdown
::: {.pullquote pq-size="3.5em"}
This text has been set to a custom size of 3.5em.
:::
```

::: {.pullquote pq-size="3.5em"}
This text has been set to a custom size of 3.5em.
:::

```markdown
::: {.pullquote pq-size="24pt"}
This text has been set to an absolute size of 24pt, identical in all three engines.
:::
```

::: {.pullquote pq-size="24pt"}
This text has been set to an absolute size of 24pt, identical in all three engines.
:::

```markdown
::: {.pullquote pq-size="1.75rem"}
This text has been set to 1.75rem, which the LaTeX and Typst pathways resolve as em.
:::
```

::: {.pullquote pq-size="1.75rem"}
This text has been set to 1.75rem, which the LaTeX and Typst pathways resolve as em.
:::

```markdown
::: {.pullquote pq-size="32px"}
This text has been set to 32px, converted to 24pt for both PDF engines.
:::
```

::: {.pullquote pq-size="32px"}
This text has been set to 32px, converted to 24pt for both PDF engines.
:::

```markdown
::: {.pullquote pq-size="2.5vw"}
This text has been set to 2.5vw, a viewport unit that only HTML resolves natively; the PDF engines fall back to em.
:::
```

::: {.pullquote pq-size="2.5vw"}
This text has been set to 2.5vw, a viewport unit that only HTML resolves natively; the PDF engines fall back to em.
:::
