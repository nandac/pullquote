#let horizontalrule = line(start: (25%,0%), end: (75%,0%))

#show terms.item: it => block(breakable: false)[
  #text(weight: "bold")[#it.term]
  #block(inset: (left: 1.5em, top: -0.4em))[#it.description]
]

#set table(
  inset: 6pt,
  stroke: none
)

#show figure.where(
  kind: table
): set figure.caption(position: top)

#show figure.where(
  kind: image
): set figure.caption(position: bottom)

#let content-to-string(content) = {
  if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(content-to-string).join("")
  } else if content.has("body") {
    content-to-string(content.body)
  } else if content == [ ] {
    " "
  }
}
#let conf(
  title: none,
  subtitle: none,
  authors: (),
  keywords: (),
  date: none,
  abstract-title: none,
  abstract: none,
  thanks: none,
  cols: 1,
  margin: (x: 1.25in, y: 1.25in),
  paper: "us-letter",
  lang: "en",
  region: "US",
  font: none,
  fontsize: 11pt,
  mathfont: none,
  codefont: none,
  linestretch: 1,
  sectionnumbering: none,
  linkcolor: none,
  citecolor: none,
  filecolor: none,
  pagenumbering: "1",
  doc,
) = {
  set document(
    title: title,
    keywords: keywords,
  )
  set document(
      author: authors.map(author => content-to-string(author.name)).join(", ", last: " & "),
  ) if authors != none and authors != ()
  set page(
    paper: paper,
    margin: margin,
    numbering: pagenumbering,
    columns: cols
  )

  set par(
    justify: true,
    leading: linestretch * 0.65em
  )
  set text(lang: lang,
           region: region,
           size: fontsize)

  set text(font: font) if font != none
  show math.equation: set text(font: mathfont) if mathfont != none
  show raw: set text(font: codefont) if codefont != none

  set heading(numbering: sectionnumbering)

  show link: set text(fill: rgb(content-to-string(linkcolor))) if linkcolor != none
  show ref: set text(fill: rgb(content-to-string(citecolor))) if citecolor != none
  show link: this => {
    if filecolor != none and type(this.dest) == label {
      text(this, fill: rgb(content-to-string(filecolor)))
    } else {
      text(this)
    }
  }

  if title != none {
    place(top, float: true, scope: "parent", clearance: 4mm, block(below: 1em, width: 100%)[
      #if title != none {
        align(center, block[
            #text(weight: "bold", size: 1.5em, hyphenate: false)[#title #if thanks != none {
                footnote(thanks, numbering: "*")
                counter(footnote).update(n => n - 1)
              }]
            #(
              if subtitle != none {
                parbreak()
                text(weight: "bold", size: 1.25em, hyphenate: false)[#subtitle]
              }
             )])
      }

      #if authors != none and authors != [] {
        let count = authors.len()
        let ncols = calc.min(count, 3)
        grid(
          columns: (1fr,) * ncols,
          row-gutter: 1.5em,
          ..authors.map(author => align(center)[
            #author.name \
            #author.affiliation \
            #author.email
          ])
        )
      }

      #if date != none {
        align(center)[#block(inset: 1em)[
            #date
          ]]
      }

      #if abstract != none {
        block(inset: 2em)[
          #text(weight: "semibold")[#abstract-title] #h(1em) #abstract
        ]
      }
    ])
  }
  doc
}
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
  // The fonts are handled by the template, but we still enforce the code block spacing
  show raw: set text(size: 1.25em, spacing: 100%)

  set par(leading: 0.8em, spacing: 1.8em)

  // Use closures to guarantee both block and text styles apply together
  show heading.where(level: 1): h => {
    set block(above: 1.925em, below: 1.265em)
    set text(size: 17.28pt, weight: "semibold")
    h
  }
  show heading.where(level: 2): h => {
    set block(above: 1.7875em, below: 1.2em)
    set text(size: 14.4pt, weight: "semibold")
    h
  }
  show heading.where(level: 3): h => {
    set block(above: 1.7875em, below: 1em)
    set text(size: 12pt, weight: "semibold")
    h
  }
  show heading.where(level: 4): h => {
    set block(above: 1.7875em, below: 1em)
    set text(size: 12pt, weight: "semibold")
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
        #text(weight: "regular", size: 20.74pt)[#title]
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
        #text(weight: "medium", size: 14.4pt)[
          #authors.map(a => a.name).join(", ")
        ]
      ]
    ]
  }

  if date != none {
    align(center)[
      #block(above: 2.5em, below: 4.5em)[
        #text(weight: "regular", size: 14.4pt)[#date]
      ]
    ]
  }

  doc
}


// --- GLOBAL FONT FIX ---
// These are defined in the global scope so content blocks (like title and authors)
// inherit them at creation time, preventing Libertinus fallbacks.
#set text(font: "Noto Serif")
#show raw: set text(font: ("Fira Mono"))
// -----------------------

#import "/test/assets/preview-styles.typ": *

#show: doc => conf(
  title: [Demonstration of the Pullquote filter for Pandoc],
  authors: (
    ( name: [Nandakumar Chandrasekhar],
      affiliation: "",
      email: "" ),
    ),
  date: [2026-08-23],
  abstract-title: [Abstract],
  margin: (bottom: 20mm,left: 20mm,right: 20mm,top: 20mm,),
  paper: "a4",
  font: "Noto Serif",
  fontsize: 12pt,
  codefont: ("Fira Mono",),
  linestretch: 1.25,
  pagenumbering: "1",
  cols: 1,
  doc,
)



