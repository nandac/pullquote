#let pullquote(
  body,
  width: 80%,                       // Matched to LaTeX 0.8\textwidth
  color: rgb("#555555"),            // Matched to HTML fallback hex
  size: 1.2em,                      // Matched to pq-size-l default
  text-align: left,                 // Matched to \raggedright
  box-align: center,                // Matched to center
  barwidth: 4pt,                    // Matched to LaTeX 4pt
  barcolor: rgb("#d9d9d9"),         // Matched to HTML fallback hex
) = {
  align(box-align)[
    #block(
      width: width,
      above: 15pt,                  // Matched to LaTeX before skip
      below: 15pt,                  // Matched to LaTeX after skip
      stroke: (left: barwidth + barcolor),
      inset: (left: 12pt, top: 4pt, bottom: 4pt), // Matched tcolorbox padding
      align(text-align)[
        #set text(fill: color, size: size)
        #set par(leading: 0.75em)   // Mimics LaTeX's 1.2\baselineskip airy feel
        // Font styles (italic, bold, mono, etc.) are injected directly here
        // by the Lua filter to seamlessly override outer scope settings.
        #body
      ]
    )
  ]
}
