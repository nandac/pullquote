---
title: "Pullquote Test: Invalid pq-family (Fatal Error)"
---

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
