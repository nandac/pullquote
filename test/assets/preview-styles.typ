// 1. Syntax Highlighting Hijacks
#let maroon = rgb("#800000")
#let _sk-ctx = state("sk-ctx", "inline")

#let Skylighting(fill: none, number: false, start: 1, sourcelines) = {
  let code-content = for ln in sourcelines {
    ln
    linebreak()
  }
  [#_sk-ctx.update("block")#block(fill: rgb("#303030"), inset: 1em, radius: 4pt, width: 100%, code-content)#_sk-ctx.update("inline")]
}

#let NormalTok(s) = context {
  if _sk-ctx.get() == "block" { text(fill: rgb("#cccccc"), raw(s)) }
  else { text(fill: maroon, raw(s)) }
}

// 2. The Master Conf Function (Handles Layout, Frontmatter & Global Styles)
#let conf(
  title: none,
  subtitle: none,
  authors: (),
  date: none,
  paper: "us-letter",
  margin: (x: 1.25in, y: 1.25in),
  cols: 1,
  // Pandoc passes "fontsize" and "linestretch" through from the defaults
  // file. Both used to fall into ..args and get silently dropped, which left
  // the body at Typst's built-in 11pt default while the LaTeX and HTML
  // pathways honored the configured 12pt -- an 8% size difference under
  // every em-relative measurement in the filter. They are named explicitly
  // now so they actually take effect; the defaults below match Pandoc's own
  // Typst template so a document that sets neither is unaffected.
  fontsize: 11pt,
  linestretch: 1,
  ..args, // Swallows the font arguments passed by Pandoc so they don't cause errors
  doc
) = {

  // --- PAGE GEOMETRY ---
  set page(
    paper: paper,
    margin: margin,
    columns: cols
  )

  // --- GLOBAL METRICS & STYLES ---
  // The font family is handled by the template; the size is applied here so
  // every em-relative measurement below (headings, frontmatter, and the
  // pullquote filter's own pq-size/pq-skip) resolves against the configured
  // body size rather than Typst's 11pt default.
  set text(size: fontsize)

  show raw: set text(size: 1.25em, spacing: 100%)

  set par(leading: linestretch * 0.65em, spacing: 1.8em)

  // Use closures to guarantee both block and text styles apply together.
  // Sizes are em-relative so the whole scale tracks "fontsize" instead of
  // being pinned to the 12pt base these ratios were originally derived from.
  show heading.where(level: 1): h => {
    set block(above: 1.925em, below: 1.265em)
    set text(size: 1.44em, weight: "semibold")
    h
  }
  show heading.where(level: 2): h => {
    set block(above: 1.7875em, below: 1.2em)
    set text(size: 1.2em, weight: "semibold")
    h
  }
  show heading.where(level: 3): h => {
    set block(above: 1.7875em, below: 1em)
    set text(size: 1em, weight: "semibold")
    h
  }
  show heading.where(level: 4): h => {
    set block(above: 1.7875em, below: 1em)
    set text(size: 1em, weight: "semibold")
    h
  }

  show link: set text(fill: blue)
  show footnote: set text(blue)
  show list: set par(justify: false)
  show enum: set par(justify: false)

  // --- TABLE RESET & STYLING ---
  set table(stroke: none)
  show table: set table(fill: rgb("F4F4F4"))
  show table: it => {
    show table.hline: none
    set table(stroke: (x, y) => if y == 0 { (bottom: 0.5pt + black) } else { none })
    box(stroke: (top: 1pt + black, bottom: 1pt + black), outset: (y: 0.3em), it)
  }

  // --- FRONTMATTER LAYOUT ---
  if title != none {
    align(center)[
      #block(below: 1.5em)[
        #text(weight: "regular", size: 1.728em)[#title]
      ]
    ]
  }

  if subtitle != none {
    align(center)[
      #block(below: 1.5em)[
        #text(weight: "semibold", size: 1.2em, fill: gray.darken(20%))[#subtitle]
      ]
    ]
  }

  if authors != none and authors.len() > 0 {
    align(center)[
      #block(above: 3em, below: 0.3em)[
        #text(weight: "medium", size: 1.2em)[
          #authors.map(a => a.name).join(", ")
        ]
      ]
    ]
  }

  if date != none {
    align(center)[
      #block(above: 2.5em, below: 4.5em)[
        #text(weight: "regular", size: 1.2em)[#date]
      ]
    ]
  }

  doc
}
