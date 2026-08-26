---
title: "Pullquote Test: Global Metadata Configuration"
pq-color: "DarkSlateGray"
pq-bar-color: "CadetBlue"
pq-width: "70%"
pq-size: "l"
pq-box-align: "center"
---

## Global Inheritance

This tests the fallback mechanism built into the Lua filter. Because this pullquote has no inline attributes attached to its div, it should automatically pull all of its styling from the YAML frontmatter (Centered, 70% width, Large size, DarkSlateGray text, and a CadetBlue bar).

```markdown
::: {.pullquote}
This quote relies entirely on the global YAML metadata for its styling and positioning. By falling back to the document frontmatter, it ensures a consistent design language across the entire project without needing to repeat code.
:::
```

::: {.pullquote}
This quote relies entirely on the global YAML metadata for its styling and positioning. By falling back to the document frontmatter, it ensures a consistent design language across the entire project without needing to repeat code.
:::

## Inline Override

This tests the exact hierarchy of the fallback logic. Inline attributes should always win. Here, we let it inherit the global centering and size, but we explicitly override the width and the colors inline.

```markdown
::: {.pullquote width="90%" color="Indigo" barcolor="MediumPurple"}
This quote selectively overrides the global width and colors, while successfully retaining the global large size and centered block alignment.
:::
```

::: {.pullquote width="90%" color="Indigo" barcolor="MediumPurple"}
This quote selectively overrides the global width and colors, while successfully retaining the global large size and centered block alignment.
:::
