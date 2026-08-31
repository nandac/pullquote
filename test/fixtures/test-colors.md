---
title: "Pullquote Test: Colors"
---

## Color Parsing (SVG Names and Hex)

This tests the robustness of the color parser, routing standard SVG color names and raw HTML hex codes to the backend compilers.

```markdown
::: {.pullquote pq-text-color="CadetBlue" pq-bar-color="Thistle" pq-bar-width="8px"}
This quote uses the SVG named color **CadetBlue** for text and the pastel **Thistle** for a thick 8px border.
:::
```

::: {.pullquote pq-text-color="CadetBlue" pq-bar-color="Thistle" pq-bar-width="8px"}
This quote uses the SVG named color **CadetBlue** for text and the pastel **Thistle** for a thick 8px border.
:::

```markdown
::: {.pullquote pq-text-color="#827397" pq-bar-color="#E9D8FD" pq-width="70%"}
This quote uses raw Hex codes: **#827397** (Muted Violet) for text and **#E9D8FD** (Pastel Lavender) for the bar.
:::
```

::: {.pullquote pq-text-color="#827397" pq-bar-color="#E9D8FD" pq-width="70%"}
This quote uses raw Hex codes: **#827397** (Muted Violet) for text and **#E9D8FD** (Pastel Lavender) for the bar.
:::

```markdown
::: {.pullquote pq-text-color="#F00" pq-bar-color="#0F0" pq-width="70%"}
This quote tests 3-character Hex shorthands: **#F00** (Red) for text and **#0F0** (Green) for the bar. The Lua filter should automatically expand these to 6 characters.
:::
```

::: {.pullquote pq-text-color="#F00" pq-bar-color="#0F0" pq-width="70%"}
This quote tests 3-character Hex shorthands: **#F00** (Red) for text and **#0F0** (Green) for the bar. The Lua filter should automatically expand these to 6 characters.
:::

## Color Blending

This tests the cross-platform color mixing syntax (`color!percentage!mix-color`). If the mix color is omitted, it automatically defaults to blending with white.

```markdown
::: {.pullquote pq-text-color="Teal!100" pq-bar-color="Teal!30" pq-bar-width="6px"}
This quote dynamically blends colors: solid **Teal** for the text, and Teal blended at **30% with white** for a softer matching bar.
:::
```

::: {.pullquote pq-text-color="Teal!100" pq-bar-color="Teal!30" pq-bar-width="6px"}
This quote dynamically blends colors: solid **Teal** for the text, and Teal blended at **30% with white** for a softer matching bar.
:::

```markdown
::: {.pullquote pq-text-color="Indigo!90!black" pq-bar-color="Indigo!20" pq-bar-width="6px"}
This quote uses a three-part blend for the text (**Indigo mixed at 90% with Black**) and a standard two-part blend for the bar.
:::
```

::: {.pullquote pq-text-color="Indigo!90!black" pq-bar-color="Indigo!20" pq-bar-width="6px"}
This quote uses a three-part blend for the text (**Indigo mixed at 90% with Black**) and a standard two-part blend for the bar.
:::
