---
title: "Pullquote Test: Invalid pq-family (Fatal Error)"
---

Like `test-errors.md`, this fixture is excluded from previews and AST snapshots and is driven by its own `Makefile` target, which asserts that the run fails. There is nothing to compare across formats: the abort happens in the filter, before any format-specific code runs, so all three targets fail identically.

This tests the `abort()` trigger for `pq-family`. A CSS-style comma-separated
font list isn't supported — see the README's "No Font Chaining" note — and
any character outside letters, digits, spaces, hyphens, and apostrophes
should instantly halt compilation rather than being spliced unescaped into
LaTeX's `\fontspec{...}`.

```markdown
::: {.pullquote pq-family="Playfair Display, Georgia"}
This text will never render because the filter will crash first.
:::
```

::: {.pullquote pq-family="Playfair Display, Georgia"}
This text will never render because the filter will crash first.
:::
