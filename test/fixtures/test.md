---
title: "Pullquote Extension Test Suite"
---

## 1. The Default Pullquote

This first test checks that if a user provides absolutely no arguments, the fallback defaults (80% width, dark gray text, light gray bar, italicized large text, centered box) trigger correctly across all formats.

::: {.pullquote}
"Typography is the craft of endowing human language with a durable visual form."
--- Robert Bringhurst
:::

Here is some standard body text following the quote to ensure vertical spacing (`skip` and `margins`) is rendering gracefully without colliding with the surrounding paragraphs.

---

## 2. Box Alignment and Width

By adjusting `width` and `boxalign`, we can float the pullquote to the side of the page to create dynamic, magazine-style layouts.

::: {.pullquote width="45%" boxalign="pq-box-right"}
This quote takes up 45% of the page width and is flushed to the right margin.
:::

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum.

::: {.pullquote width="60%" boxalign="pq-box-left" align="pq-align-center"}
This one takes up 60%, floats to the left margin, but the text *inside* it is centered.
:::

Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. Nullam varius, turpis et commodo pharetra, est eros bibendum elit, nec luctus magna felis sollicitudin mauris. Integer in mauris eu nibh euismod gravida.

---

## 3. The Typography Engine

This tests the semantic sizes and the CSS-like class injection for font weights, families, and styles.

::: {.pullquote .pq-weight-bold .pq-family-sans size="pq-size-xl"}
This is an Extra Large (XL), Bold, Sans-Serif quote.
:::

::: {.pullquote .pq-family-mono size="pq-size-s" align="pq-align-right"}
This is a Small (S), Monospace quote, aligned to the right.
:::

::: {.pullquote .pq-style-smallcaps .pq-weight-bold size="pq-size-2xl"}
This is a 2XL, Bold, Small-Caps quote.
:::

---

## 4. Color Parsing (SVG Names and Hex)

This tests the robustness of the color parser. It should seamlessly route standard SVG color names and raw HTML hex codes to the appropriate backend commands.

::: {.pullquote color="Tomato" barcolor="DarkSlateBlue" barwidth="8px"}
This quote uses the SVG named color **Tomato** for text and **DarkSlateBlue** for a thick 8px border.
:::

::: {.pullquote color="#2ECC71" barcolor="#E74C3C" width="70%"}
This quote uses raw Hex codes: **#2ECC71** (Green) for text and **#E74C3C** (Red) for the bar.
:::

---

## 5. The Extreme Stress Test

Finally, we combine everything: custom width, extreme size, custom colors, custom alignments, and multiple font styles in a single fenced Div.

::: {.pullquote .pq-weight-bold .pq-family-serif .pq-style-upright size="pq-size-3xl" align="pq-align-center" boxalign="pq-box-center" width="95%" color="DarkGoldenrod" barcolor="MidnightBlue" barwidth="12px"}
THE ULTIMATE TEST
:::
