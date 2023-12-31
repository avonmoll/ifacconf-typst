//==============================================================================
// template.typ 2023-11-17 Alexander Von Moll
// Template for IFAC meeting papers
//
// Adapted from ifacconf.cls
//==============================================================================

// This function gets your whole document as its `body` and formats
// it as an article in the style of the IEEE.
#let ifacconf(
  // The paper's title.
  title: "Paper Title",

  // An array of authors. For each author you can specify a name,
  // department, organization, location, and email. Everything but
  // but the name is optional.
  authors: (),

  // The paper's abstract. Can be omitted if you don't have one.
  abstract: none,

  // A list of index terms to display after the abstract.
  keywords: (),

  // Sponsor or financial support acknowledgment
  sponsor: none,

  // The paper's content.
  body
) = {
  // Set document metadata.
  set document(title: title, author: authors.map(author => author.name))

  // Set the body font.
  set text(font: "New Computer Modern", size: 10pt)

  // Configure the page.
  set page(
    paper: "a4",
    // The margins depend on the paper size.
    margin: (x: 1.5cm, y: 2.5cm)
  )

  // Set line spacing
  set par(leading: 0.4em)

  // Configure equation numbering and spacing.
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 0.65em)

  // Configure appearance of equation references
  show ref: it => {
    if it.element != none and it.element.func() == math.equation {
      // Override equation references.
      link(
        it.element.label,
        numbering(
          it.element.numbering,
          ..counter(math.equation).at(it.element.location())
        )
      )
    } else {
      // Other references as usual.
      it
    }
  }

  // Configure lists.
  set enum(indent: 10pt, body-indent: 9pt)
  set list(indent: 10pt, body-indent: 9pt)

  // Configure Tables
  // NOTE: more specific rules (e.g., "where" rules) need to come before more general rules for the same element
  show figure.caption.where(kind: "table"): set align(center)
  show figure.where(kind: "table"): set figure.caption(position: top)

  // Configure Figures
  // NOTE: multiline show rules using a code block do not seem to be working
  set figure.caption(separator: ". ")
  show figure.caption: set align(left)
  show figure.caption: set par(hanging-indent: 8mm)
  set figure(numbering: "1", supplement: [Fig.])

  // Configure Footnotes
  set footnote(numbering: "1")
  set footnote.entry(indent: 0mm, separator: line(length: 60%, stroke: 0.4pt), clearance: 0.35em)

  // Configure headings.
  set heading(numbering: "1.1.1")
  show heading: it => locate(loc => {
    // Find out the final number of the heading counter.
    let levels = counter(heading).at(loc)
    let deepest = if levels != () {
      levels.last()
    } else {
      1
    }

    set text(10pt, weight: "regular")
    if it.level == 1 [
      // First-level headings are centered caps.
      // We don't want to number of the acknowledgment section.
      #let is-ack = it.body in ([Acknowledgments], [Acknowledgements], [REFERENCES])
      #set align(center)
      // #show: upper
      #v(20pt, weak: true)
      #if it.numbering != none and not is-ack {
        numbering("1.", deepest)
        h(5pt, weak: true)
      }
      #upper(it.body)
      #v(13pt, weak: true)
    ] else if it.level == 2 [
      // Second-level headings left-aligned and italic.
      #set text(style: "italic")
      #v(16pt, weak: true)
      #if it.numbering != none {
        numbering("1.1", ..levels)
        h(6pt, weak: true)
      }
      #it.body
      #v(16pt, weak: true)
    ] else {
      // Third level headings are run-ins too, but different.
      if it.level == 3 {
        set text(style: "italic")
        it.body
        h(8pt)
      }
    }
  })


  let star = [\u{1F7B1}]
  grid(
    columns: (3.5cm, 1fr, 3.5cm),
    [],
    [
      #set align(center)

      // Display the paper's title.
      #v(1cm)
      #let title-font-size = 14pt
      #if sponsor == none {
        text(title-font-size, strong(title))
      } else {
        set footnote(numbering: "*")
        // text(12pt, strong[#title#footnote[#sponsor]])
        text(14pt, [*#title*#h(-2pt)#text(20pt, super[ #star])])
      }
      #v(2mm)

      // Display the authors list.
      #let alist = ()
      #for (i, a) in authors.enumerate() {
        let mark = text(8pt, [\*] * (i + 1))
        alist.push(box([#strong(a.name)#h(2pt)#mark]))
      }
      #alist.join(h(4pt))
      #v(1mm)

      // Display the affiliations list
      // #set text(style: "italic")
      #for (i, a) in authors.enumerate() {
        let mark = text(8pt, [\*] * (i + 1))
        let affil-array = ()
        if "department" in a { affil-array.push(a.department) }
        if "organization" in a { affil-array.push(a.organization) }
        if "address" in a { affil-array.push(a.address) }
        if "email" in a { affil-array.push([(e-mail: #a.email)]) }
        let affil = affil-array.join(", ")
        [#mark #emph(affil)]
        if i != (authors.len() - 1) [ \ ]
      }
      #v(3mm, weak: false)
    ],
    []
  )

  // Display abstract and keywords.
  if abstract != none {
    grid(
      columns: (1.7cm, 1fr, 1.7cm),
      [],
      [
        #set par(justify: true)
        #line(length: 100%, stroke: 0.4pt)
        #v(-1.5mm)
        *Abstract:* #abstract
        #v(2mm)
        #if keywords != () [
          _Keywords:_ #keywords.join(", ")
        ]
        #v(-2.5mm)
        #line(length: 100%, stroke: 0.4pt)
      ],
      []
    )
    v(0mm, weak: false)
  }
  
  // Start two column mode and configure paragraph properties.
  show: columns.with(2, gutter: 5mm)
  // show: columns.with(2, gutter: 3.5mm)
  set par(justify: true, leading: 0.4em)
  show par: set block(spacing: 3.5mm)

  if sponsor != none {
    scale(x: 0%, y:0%)[#footnote(numbering: (..nums) => super(text(7pt, star)))[#h(5pt)#sponsor]]
    v(-9mm)
    counter(footnote).update(0)
  }

  // Display the paper's contents.
  body

}

#import "@preview/ctheorems:1.1.0": *
#let ifacconf-rules(doc) = { 
  show bibliography: set block(spacing: 5pt)
  show: thmrules
  doc
}

#let tablefig = figure.with(supplement: [Table], kind: "table")

#let appendix-counter = counter("appendix")
#let appendix = it => {
  appendix-counter.step()
  heading(numbering: none, supplement: "Appendix")[
    A#lower[ppendix] #appendix-counter.display("A.")#h(5pt)#it
  ]
}

#let bibliography = bibliography.with(title: "References", style: "ifac-conference.csl")

// Support for numbered Theorems, etc.
// NOTE: these definitions may be able to be cleaned up and compressed in the future
#let theorem = thmenv(
  "theorem",
  none,
  none,
  (name, number, body, ..args) => {
    set align(left)
    set par(justify: true)
    block(inset: 0mm, radius: 0mm, breakable: false, width: 100%)[_Theorem #number#if name != none [ (#name)]._#h(2pt)#body]
  },
).with(
  supplement: "Theorem",
  )

#let lemma = thmenv(
  "lemma",
  none,
  none,
  (name, number, body, ..args) => {
    set align(left)
    set par(justify: true)
    block(inset: 0mm, radius: 0mm, breakable: false, width: 100%)[_Lemma #number#if name != none [ (#name)]._#h(2pt)#body]
  },
).with(
  supplement: "Lemma",
  )

#let claim = thmenv(
  "claim",
  none,
  none,
  (name, number, body, ..args) => {
    set align(left)
    set par(justify: true)
    block(inset: 0mm, radius: 0mm, breakable: false, width: 100%)[_Claim #number#if name != none [ (#name)]._#h(2pt)#body]
  },
).with(
  supplement: "Claim",
  )

#let conjecture = thmenv(
  "conjecture",
  none,
  none,
  (name, number, body, ..args) => {
    set align(left)
    set par(justify: true)
    block(inset: 0mm, radius: 0mm, breakable: false, width: 100%)[_Conjecture #number#if name != none [ (#name)]._#h(2pt)#body]
  },
).with(
  supplement: "Conjecture",
  )

#let corollary = thmenv(
  "corollary",
  none,
  none,
  (name, number, body, ..args) => {
    set align(left)
    set par(justify: true)
    block(inset: 0mm, radius: 0mm, breakable: false, width: 100%)[_Corollary #number#if name != none [ (#name)]._#h(2pt)#body]
  },
).with(
  supplement: "Corollary",
  )

#let fact = thmenv(
  "fact",
  none,
  none,
  (name, number, body, ..args) => {
    set align(left)
    set par(justify: true)
    block(inset: 0mm, radius: 0mm, breakable: false, width: 100%)[_Fact #number#if name != none [ (#name)]._#h(2pt)#body]
  },
).with(
  supplement: "Fact",
  )

#let hypothesis = thmenv(
  "hypothesis",
  none,
  none,
  (name, number, body, ..args) => {
    set align(left)
    set par(justify: true)
    block(inset: 0mm, radius: 0mm, breakable: false, width: 100%)[_Hypothesis #number#if name != none [ (#name)]._#h(2pt)#body]
  },
).with(
  supplement: "Hypothesis",
  )

#let proposition = thmenv(
  "proposition",
  none,
  none,
  (name, number, body, ..args) => {
    set align(left)
    set par(justify: true)
    block(inset: 0mm, radius: 0mm, breakable: false, width: 100%)[_Proposition #number#if name != none [ (#name)]._#h(2pt)#body]
  },
).with(
  supplement: "Proposition",
  )

#let criterion = thmenv(
  "criterion",
  none,
  none,
  (name, number, body, ..args) => {
    set align(left)
    set par(justify: true)
    block(inset: 0mm, radius: 0mm, breakable: false, width: 100%)[_Criterion #number#if name != none [ (#name)]._#h(2pt)#body]
  },
).with(
  supplement: "Criterion",
  )

#let proof = thmbox(
  "proof",
  "Proof",
  inset: 0mm,
  base: none,
  bodyfmt: body => [#body #h(1fr) $square$],
  separator: [.#h(2pt)]
).with(numbering: none)

#let footnote = it => footnote[#h(4pt)#it]

