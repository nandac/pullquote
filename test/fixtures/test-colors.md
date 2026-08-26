---
title: "Pullquote Test: Colors"
---

## Color Parsing (SVG Names and Hex)

This tests the robustness of the color parser, routing standard SVG color names and raw HTML hex codes to the backend compilers.

```markdown
::: {.pullquote color="CadetBlue" barcolor="Thistle" barwidth="8px"}
This quote uses the SVG named color **CadetBlue** for text and the pastel **Thistle** for a thick 8px border.
:::
```

::: {.pullquote color="CadetBlue" barcolor="Thistle" barwidth="8px"}
This quote uses the SVG named color **CadetBlue** for text and the pastel **Thistle** for a thick 8px border.
:::

```markdown
::: {.pullquote color="#827397" barcolor="#E9D8FD" width="70%"}
This quote uses raw Hex codes: **#827397** (Muted Violet) for text and **#E9D8FD** (Pastel Lavender) for the bar.
:::
```

::: {.pullquote color="#827397" barcolor="#E9D8FD" width="70%"}
This quote uses raw Hex codes: **#827397** (Muted Violet) for text and **#E9D8FD** (Pastel Lavender) for the bar.
:::

```markdown
::: {.pullquote color="#F00" barcolor="#0F0" width="70%"}
This quote tests 3-character Hex shorthands: **#F00** (Red) for text and **#0F0** (Green) for the bar. The Lua filter should automatically expand these to 6 characters.
:::
```

::: {.pullquote color="#F00" barcolor="#0F0" width="70%"}
This quote tests 3-character Hex shorthands: **#F00** (Red) for text and **#0F0** (Green) for the bar. The Lua filter should automatically expand these to 6 characters.
:::

## Color Blending

This tests the cross-platform color mixing syntax (`color!percentage!mix-color`). If the mix color is omitted, it automatically defaults to blending with white.

```markdown
::: {.pullquote color="Teal!100" barcolor="Teal!30" barwidth="6px"}
This quote dynamically blends colors: solid **Teal** for the text, and Teal blended at **30% with white** for a softer matching bar.
:::
```

::: {.pullquote color="Teal!100" barcolor="Teal!30" barwidth="6px"}
This quote dynamically blends colors: solid **Teal** for the text, and Teal blended at **30% with white** for a softer matching bar.
:::

```markdown
::: {.pullquote color="Indigo!90!Black" barcolor="Indigo!20" barwidth="6px"}
This quote uses a three-part blend for the text (**Indigo mixed at 90% with Black**) and a standard two-part blend for the bar.
:::
```

::: {.pullquote color="Indigo!90!Black" barcolor="Indigo!20" barwidth="6px"}
This quote uses a three-part blend for the text (**Indigo mixed at 90% with Black**) and a standard two-part blend for the bar.
:::
