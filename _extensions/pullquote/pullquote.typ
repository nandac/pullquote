// ==============================================================================
// pullquote.typ
// Companion Typst component for the pullquote.lua Pandoc filter (v2.0.0+)
// ==============================================================================

#let pullquote(
  width: 80%,
  color: auto,
  barwidth: 4pt,
  barcolor: rgb("#D9D9D9"),
  paddingleft: 12pt,
  paddingright: 0pt,
  paddingtop: 4pt,
  paddingbottom: 4pt,
  size: auto,
  text-align: "left",
  box-align: "center",
  weight: "normal",
  style: "normal",
  font: auto,
  skip: auto,
  body
) = {

  // 1. Map Semantic Size
  let size-map = (
    "s": 0.85em,
    "m": 1.0em,
    "l": 1.2em,
    "xl": 1.5em,
    "2xl": 2.0em
  )

  let actual-size = if type(size) == str and size in size-map {
    size-map.at(size)
  } else if size != auto {
    size
  } else {
    1em // Explicitly inherit current size instead of passing 'auto'
  }

  // 2. Map Semantic Text Alignment
  let align-map = (
    "left": left,
    "right": right,
    "center": center
  )
  let actual-text-align = if type(text-align) == str and text-align in align-map {
    align-map.at(text-align)
  } else {
    left
  }
  let do-justify = (text-align == "justify")

  // 3. Map Semantic Font Style/Weight
  let actual-style = if style == "italic" {
    "italic"
  } else if style == "slanted" {
    "oblique"
  } else {
    "normal"
  }

  let actual-weight = if weight == "bold" or weight == "medium" {
    "bold"
  } else {
    "regular"
  }

  // 4. Map Semantic Line-Height (Leading)
  let actual-skip = if skip == auto {
    0.5em // 1.35 - 0.85 fallback
  } else {
    (float(skip) - 0.85) * 1em
  }

  // 5. Structure the Layout Box
  align(if box-align == "center" { center } else if box-align == "right" { right } else { left })[
    #block(
      width: width,
      stroke: (left: barwidth + barcolor),
      inset: (left: paddingleft, right: paddingright, top: paddingtop, bottom: paddingbottom),
      breakable: true
    )[
      #set text(
        size: actual-size,
        fill: if color != auto { color } else { black },
        style: actual-style,
        weight: actual-weight,
        font: if font != auto { font } else { "Libertinus Serif" }
      )
      #set par(leading: actual-skip, justify: do-justify)
      #set align(actual-text-align)

      #if style == "smallcaps" [
        #smallcaps(body)
      ] else [
        #body
      ]
    ]
  ]
}
