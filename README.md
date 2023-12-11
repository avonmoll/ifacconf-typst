# IFAC Conference Template for Typst

IFAC stands for [International Federation of Automatic Control](https://ifac-control.org/).
This repository is meant to be a port of the existing author tools for conference papers (e.g., for LaTeX, see [ifacconf_latex.zip](https://www.ifac-control.org/conferences/author-guide/copy_of_ifacconf_latex.zip/view)) for Typst.

![image](https://github.com/avonmoll/ifacconf-typst/assets/4260850/2fffa48d-0551-4956-b5be-cc4094733a9c)

# Minimal Working Example

```typst
#import "template.typ": *
#show: ifacconf-rules
#show: ifacconf.with(
  title: "Minimal Working Example",
  authors: (
    (
      name: "First A. Author",
      department: "Engineering",
      organization: "National Institute of Standards and Technology",
      address: "Boulder, CO 80305 USA",
      email: "author@boulder.nist.gov"
    ),
  ),
  abstract: [
    Abstract should be 50-100 words.
  ],
  keywords: ("keyword1", "keyword2"),
  sponsor: [
    Sponsor information.
  ],
)

= Introduction

A minimum working example (with bibliography) @Abl56.

#lorem(80)

#lorem(80)

#bibliography("refs.bib")
```

# Full(er) Example

See `ifacconf.typ`.

# Installation

For now, download `template.typ` and `ifac-conference.csl` and place in the same directory as your document.
A more structured template experience for Typst is likely going to come sometime soon (see [this comment from the creators](https://github.com/typst/templates/pull/18#issuecomment-1798188384))

# Dependencies

- typst 0.9.0 (possibly works on other versions but only tested on 0.9.0)
- ctheorems 1.1.0 (a Typst package for handling theorem-like environments)

# Notes, features, etc.

- the call to `#show: ifacconf-rules` is necessary for some show rules defined in `template.typ` to get activated
- `ifac-conference.csl` is a lightly modified version of `apa.csl` and is included in order to change the citation format from, e.g., `(Able 1956)` to `Able (1956)` in order to match `ifacconf_latex`
- Tables have formatting rules that get activated inside calls to `figure` with `kind: "table"`; a convenience function `tablefig` is provided which sets this automatically
- use of the `tablex` Typst package (as shown in `ifacconf.typ`) was needed to produce a table with only horizontal lines
- all theorem-like environments that were available in `ifacconf_latex` are defined in `template.typ`; simply call, for example, `#theorem[Content...] ... #proof[Proof...]`
- the LaTeX version does not include a QED symbol at the end of proofs, however one is included here (this is easy to change)
- use of multi-cite, e.g., `@Abl56 @AbTaRu54` results in an additional space after the last citation and is therefore not recommended before the end of a sentence
- Typst did not seem to like BibTeX citation keys containing colons (which was how they came from `ifacconf_latex`)
- alignment for linebreaks in long equations is somewhat manual (e.g., for equation (2) in `ifacconf.typ`) but probably there is a better way to handle this now or in the future
- the files `refs.bib` (essentially) and `bifurcation.jpg` come from `ifacconf_latex`
- the file `ifacconf.typ` is modeled directly after `ifacconf.tex` by Juan a. de la Puente

# License

The `ifac-conference.csl` is licensed according to `CSL LICENSE.md` (CC BY/SA 4.0) because it is a lightly modified version of `apa.csl` by Brenton M. Wiernik which is also licensed by a CC BY/SA license.
