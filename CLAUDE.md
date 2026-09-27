# CLAUDE.md

This file provides guidance to Claude Code (or any coding agent) working in this repository.

## Project

duckweedSynCom is a research compendium studying interactions between duckweed
(*Lemna minor*) and a synthetic bacterial community (SynCom). Analyses are
Quarto notebooks (R, plus one Python-engine notebook), rendered to a public
Quarto website. This is **not an R package**: there is no `DESCRIPTION`, no
`tests/`, and no `renv` - packages are expected to already be available in the
user library.

The layout deliberately mirrors two sibling projects, `hambiEvoEnvCoexist` and
`MCTdownUnder`; when a convention here is ambiguous, those repos are the
reference.

## Layout

```
duckweedSynCom/
├── _quarto.yml     # Website config: explicit render: list, sidebar nav, format/execute defaults
├── index.qmd       # Landing page (citation-style YAML front matter, manuscript status, availability)
├── README.md       # GitHub-facing readme
├── R/              # Shared helper functions only - no analysis, no paths, no side effects
│   └── plotting.R    #   theme_project(), capit(), make_palette() - sourced by scripts/ notebooks
├── scripts/        # All analysis as numbered Quarto notebooks: NN_track/NN_stage.qmd
│   ├── 01_sanger_seq/                          # 16S Sanger trace QC + assembly (Python-engine notebook)
│   ├── 02_bac_taxonomy/                        # Bacterial isolate taxonomy from SILVA ACT, feeds off 01
│   ├── 03_duckweed_genotyping/                 # Duckweed species barcode genotyping (independent of 01/02)
│   ├── 04_lemna_bacteria_coculture_frondarea/  # Coculture frond-area growth; 01 feeds 02 (Bayesian model)
│   └── _notrack/                               # Gitignored local-only work in progress
├── data/
│   ├── raw/         # One dated dir per acquisition batch, never modified, committed
│   ├── interim/     # Cached model fits (.rds) etc., mirrors scripts/ track names
│   ├── processed/   # Cleaned analysis-ready tables, mirrors scripts/ track names, committed
│   └── _notrack/, processed/_notrack/   # Gitignored local-only/orphaned data
└── output/
    ├── figures/     # Manuscript figures (svg/png), flat, descriptive names
    └── tables/      # Manuscript tables
```

## Naming convention

`scripts/<NN>_<track>/<NN>_<stage>.qmd`. Directory `NN` groups a track of
related analysis; file `NN` is the stage within that track, meant to run in
numeric order. Two tracks can share a stage number when neither depends on
the other (e.g. `02_bac_taxonomy` and `03_duckweed_genotyping` both depend
only on raw data, not on each other) - see the pipeline table below.
`data/processed/<track>/` and `data/interim/<track>/` mirror the
`scripts/<track>` name exactly.

New notebooks must be added to **both** the `render:` list and a `sidebar`
`contents:` entry in `_quarto.yml`.

## Pipeline

| Track | Produces | Depends on |
|---|---|---|
| `01_sanger_seq` | consensus 16S sequences, trace QC metrics | raw Sanger `.ab1` traces |
| `02_bac_taxonomy` | isolate taxonomy table + composition/phylogeny figures | `01_sanger_seq` output |
| `03_duckweed_genotyping` | duckweed species barcode assignments | raw Sanger `.ab1` traces (independent of 01/02) |
| `04_.../01_read_frondarea` | cleaned frond-area table | raw plate-reader exports |
| `04_.../02_growth_model` | Bayesian growth model, per-strain effect estimates | `04_.../01_read_frondarea` output |

## Notebook skeleton

Every notebook opens the same way: `# Setup` → `## Libraries` (`library()`
calls, one per line, then `source(here::here("R", "..."))`) → `## Global
variables` (path constants built with `here::here()`, then `fs::dir_create()`
on every output dir the notebook writes to). Notebook-local helper functions
are defined near their first use rather than front-loaded into a separate
`## Functions` section.

## Figures

Figures use chunk options, not a caption div:
````
```{r}
#| label: fig-xyz
#| fig-cap: "Caption text."
<plotting code>
```
````
- A `fig-cap` containing a literal `"` must be escaped (`\"`), since it's a
  normal YAML string.
- A caption that needs a *dynamic* value (a count computed earlier in the
  notebook) uses knitr's `!expr` tag instead of a plain string:
  `#| fig-cap: !expr paste0("... ", nrow(x), " ...")`. This is evaluated in
  the chunk's own environment right before it runs, so it can reference any
  object defined in a prior chunk.
- A figure that is a hand-saved external image (e.g. the matplotlib-generated
  QC figure in `01_sanger_seq`) instead uses a plain captioned markdown
  image: `![Caption](path){#fig-id}`.

## Execute defaults

`execute: output: false` site-wide (matches MCTdownUnder) - a chunk's result
(printed tibble, model summary, plot, `DT::datatable`, etc.) is hidden unless
the chunk explicitly sets `#| output: true`. Chunks that only write files or
define functions/variables never need this. Long-running sampler progress
(e.g. `brm()` calls) is deliberately left un-shown even though it executes,
to avoid dumping console spam into the rendered page.

## Deliberate divergences from MCTdownUnder

- Native pipe `|>` used exclusively (MCTdownUnder mixes `%>%`/`|>`) - do not
  introduce `%>%`.
- `tidy: false` (code is formatted with `air`, see `air.toml`; MCTdownUnder's
  `tidy: true` + formatR would fight `air` and can mangle native pipes).

`AGENTS.md` is intentionally not committed here (see `.gitignore`) - keep any
local copy in sync with this file by hand if you use one.
