---
title: "Pullquote Test: Text Alignment"
---

`pq-text-align` sets the ragged edge of the text *within* the box. It is independent of `pq-box-align`, which positions the box itself on the page — that one has its own fixture in `test-box-align.md`. Each engine reaches the same result by its own route: CSS `text-align`, LaTeX's `\raggedright`/`\centering`/`\raggedleft`, and Typst's `align`. Compare the three rendered previews: the ragged edge must fall on the same side in all three, though the exact wrap points can differ, because the three engines use different line-breaking algorithms.

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
