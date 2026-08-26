---
title: "Pullquote Test: Text Alignment"
---

## Inner Text Alignment

This tests the alignment of the text *inside* the pullquote box, independently of where the box itself floats on the page. By using longer paragraphs that wrap across multiple lines, the ragged edges make the alignment behavior clearly visible.

```markdown
::: {.pullquote pq-text-align="left"}
This text is forced to align to the left edge of the pullquote box. By extending the length of this quote so that it naturally wraps across multiple lines, the ragged right edge becomes immediately apparent, proving that the left alignment is working perfectly.
:::
```

::: {.pullquote pq-text-align="left"}
This text is forced to align to the left edge of the pullquote box. By extending the length of this quote so that it naturally wraps across multiple lines, the ragged right edge becomes immediately apparent, proving that the left alignment is working perfectly.
:::

```markdown
::: {.pullquote pq-text-align="center"}
This text is centered perfectly within the pullquote box. By extending the length of this quote so that it naturally wraps across multiple lines, the ragged edges on both the left and right sides become immediately apparent, proving that the center alignment is working perfectly.
:::
```

::: {.pullquote pq-text-align="center"}
This text is centered perfectly within the pullquote box. By extending the length of this quote so that it naturally wraps across multiple lines, the ragged edges on both the left and right sides become immediately apparent, proving that the center alignment is working perfectly.
:::

```markdown
::: {.pullquote pq-text-align="right"}
This text is flushed to the right edge of the pullquote box. By extending the length of this quote so that it naturally wraps across multiple lines, the ragged left edge becomes immediately apparent, proving that the right alignment is working perfectly.
:::
```

::: {.pullquote pq-text-align="right"}
This text is flushed to the right edge of the pullquote box. By extending the length of this quote so that it naturally wraps across multiple lines, the ragged left edge becomes immediately apparent, proving that the right alignment is working perfectly.
:::
