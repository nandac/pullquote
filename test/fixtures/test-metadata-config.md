---
title: "Pullquote Test: Global Metadata Configuration"
pq-text-color: "DarkSlateGray"
pq-bar-color: "CadetBlue"
pq-width: "70%"
pq-size: "l"
pq-box-align: "center"
---

Every `pq-*` attribute can also be set once in the document's YAML frontmatter, as this fixture's own header does. The filter checks the fenced div first and falls back to the metadata, so these two sections test the two halves of that lookup. Compare the three rendered previews: resolution happens in the filter, before any format-specific code runs, so all three engines should inherit and override identically — any divergence here is a filter bug rather than an engine difference.

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

Note that the inline names carry the same `pq-` prefix as everywhere else. The filter only reads prefixed attributes, so a bare `width="90%"` is not an override — Pandoc passes it straight through as a literal HTML attribute and the global value silently stays in force.

```markdown
::: {.pullquote pq-width="90%" pq-text-color="Indigo" pq-bar-color="MediumPurple"}
This quote selectively overrides the global width and colors, while successfully retaining the global large size and centered block alignment.
:::
```

::: {.pullquote pq-width="90%" pq-text-color="Indigo" pq-bar-color="MediumPurple"}
This quote selectively overrides the global width and colors, while successfully retaining the global large size and centered block alignment.
:::
