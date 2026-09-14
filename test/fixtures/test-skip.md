---
title: "Pullquote Test: Interline Spacing"
---

## Semantic Scale

The `pq-skip` attribute uses a strict semantic scale to guarantee visually identical line spacing across HTML, LaTeX, and Typst. Every quote below uses the same `pq-size` and the same wrapped text, so spacing is the only variable. Compare the three rendered formats side by side.

```markdown
::: {.pullquote pq-size="m"}
No pq-skip at all. Automatically falls back to the standard base spacing.
:::
```

::: {.pullquote pq-size="m"}
No pq-skip at all. Automatically falls back to the standard base spacing.
:::

```markdown
::: {.pullquote pq-size="m" pq-skip="tight"}
A pq-skip of `tight` pulls the lines closer together, ideal for large display text or dense blocks.
:::
```

::: {.pullquote pq-size="m" pq-skip="tight"}
A pq-skip of `tight` pulls the lines closer together, ideal for large display text or dense blocks.
:::

```markdown
::: {.pullquote pq-size="m" pq-skip="base"}
A pq-skip of `base` provides the standard, readable paragraph spacing.
:::
```

::: {.pullquote pq-size="m" pq-skip="base"}
A pq-skip of `base` provides the standard, readable paragraph spacing.
:::

```markdown
::: {.pullquote pq-size="m" pq-skip="relaxed"}
A pq-skip of `relaxed` opens up the lines for a spacious, magazine-like feel.
:::
```

::: {.pullquote pq-size="m" pq-skip="relaxed"}
A pq-skip of `relaxed` opens up the lines for a spacious, magazine-like feel.
:::

```markdown
::: {.pullquote pq-size="m" pq-skip="loose"}
A pq-skip of `loose` provides maximum breathing room, functioning essentially as double spacing.
:::
```

::: {.pullquote pq-size="m" pq-skip="loose"}
A pq-skip of `loose` provides maximum breathing room, functioning essentially as double spacing.
:::
