---
title: "Pullquote Test: Interline Spacing"
---

## Multiplier Scale

`pq-skip` is a baseline-to-baseline multiple in every engine, so the same
value should produce the same line spacing in HTML, LaTeX, and Typst. Every
quote below uses the same `pq-size` and the same wrapped text, so spacing is
the only variable. Compare the three rendered formats side by side.

```markdown
::: {.pullquote pq-size="m"}
No pq-skip at all. HTML and Typst default to 1.5; LaTeX leaves the size's own natural leading alone.
:::
```

::: {.pullquote pq-size="m"}
No pq-skip at all. HTML and Typst default to 1.5; LaTeX leaves the size's own natural leading alone.
:::

```markdown
::: {.pullquote pq-size="m" pq-skip="1.0"}
A pq-skip of 1.0 is single spacing. LaTeX will not set a baselineskip tighter than the natural line height, so it clamps here where HTML and Typst do not.
:::
```

::: {.pullquote pq-size="m" pq-skip="1.0"}
A pq-skip of 1.0 is single spacing. LaTeX will not set a baselineskip tighter than the natural line height, so it clamps here where HTML and Typst do not.
:::

```markdown
::: {.pullquote pq-size="m" pq-skip="1.25"}
A pq-skip of 1.25 is a modest opening up of the lines, still tighter than the default.
:::
```

::: {.pullquote pq-size="m" pq-skip="1.25"}
A pq-skip of 1.25 is a modest opening up of the lines, still tighter than the default.
:::

```markdown
::: {.pullquote pq-size="m" pq-skip="1.5"}
A pq-skip of 1.5 matches the default that HTML and Typst apply when the attribute is omitted.
:::
```

::: {.pullquote pq-size="m" pq-skip="1.5"}
A pq-skip of 1.5 matches the default that HTML and Typst apply when the attribute is omitted.
:::

```markdown
::: {.pullquote pq-size="m" pq-skip="2.0"}
A pq-skip of 2.0 is double spacing, the most common reason to reach for this attribute at all.
:::
```

::: {.pullquote pq-size="m" pq-skip="2.0"}
A pq-skip of 2.0 is double spacing, the most common reason to reach for this attribute at all.
:::

```markdown
::: {.pullquote pq-size="m" pq-skip="2.5"}
A pq-skip of 2.5 is well past double spacing, useful mainly for very short display quotes.
:::
```

::: {.pullquote pq-size="m" pq-skip="2.5"}
A pq-skip of 2.5 is well past double spacing, useful mainly for very short display quotes.
:::

## Explicit Units

`pq-skip` also accepts an exact length instead of a bare multiplier. `em` and
`rem` resolve against the pullquote's own size; `px` is converted to `pt` for
the two PDF engines, and Typst receives absolute lengths as `<length> - 1em`
so they still describe a baseline-to-baseline distance.

```markdown
::: {.pullquote pq-size="m" pq-skip="1.4em"}
An em-based pq-skip of 1.4em scales with the pullquote's own font size.
:::
```

::: {.pullquote pq-size="m" pq-skip="1.4em"}
An em-based pq-skip of 1.4em scales with the pullquote's own font size.
:::

```markdown
::: {.pullquote pq-size="m" pq-skip="1.5rem"}
A rem-based pq-skip of 1.5rem is converted to em for the LaTeX and Typst pathways.
:::
```

::: {.pullquote pq-size="m" pq-skip="1.5rem"}
A rem-based pq-skip of 1.5rem is converted to em for the LaTeX and Typst pathways.
:::

```markdown
::: {.pullquote pq-size="m" pq-skip="20pt"}
An absolute pq-skip of 20pt is a fixed baseline-to-baseline distance that does not scale with pq-size.
:::
```

::: {.pullquote pq-size="m" pq-skip="20pt"}
An absolute pq-skip of 20pt is a fixed baseline-to-baseline distance that does not scale with pq-size.
:::

```markdown
::: {.pullquote pq-size="m" pq-skip="24px"}
A pixel pq-skip of 24px is converted to 18pt for both PDF engines at the standard 96dpi to 72pt ratio.
:::
```

::: {.pullquote pq-size="m" pq-skip="24px"}
A pixel pq-skip of 24px is converted to 18pt for both PDF engines at the standard 96dpi to 72pt ratio.
:::

## Interaction With pq-size

Because a bare multiplier is relative to the pullquote's own font size, the
same `pq-skip` produces proportionally larger spacing at a larger `pq-size`.

```markdown
::: {.pullquote pq-size="2xl" pq-skip="1.5"}
The same 1.5 multiplier at a much larger size, to confirm the spacing tracks the font rather than the document.
:::
```

::: {.pullquote pq-size="2xl" pq-skip="1.5"}
The same 1.5 multiplier at a much larger size, to confirm the spacing tracks the font rather than the document.
:::
