# Shared ggplot theme and palette helpers, following the conventions
# established in hambiEvoEnvCoexist/R/communities.R. Sourced by the
# notebooks in scripts/.

# Project default theme
theme_project <- function() {
  ggplot2::theme_classic() +
    ggplot2::theme(
      panel.grid.major = ggplot2::element_line(color = "grey90"),
      panel.grid.minor = ggplot2::element_blank(),
      strip.placement = "outside",
      strip.background = ggplot2::element_blank(),
      legend.position = "inside",
      legend.key.size = ggplot2::unit(7, "mm"),
      legend.background = ggplot2::element_rect(
        fill = "grey95",
        colour = "grey20",
        linewidth = 0.5
      ),
      legend.title = ggplot2::element_blank(),
      legend.justification.inside = c(0.95, 0.95)
    )
}

# Cap axis lines at the outermost tick, rather than letting them run past it
capit <- function() {
  ggplot2::guides(
    x = ggplot2::guide_axis(cap = TRUE),
    y = ggplot2::guide_axis(cap = TRUE)
  )
}

# Named color palette for an arbitrary set of categories. Up to 12 categories
# draw directly from RColorBrewer's "Paired" palette; beyond that, adjacent
# interpolated Brewer colors become indistinguishable, so a Polychrome
# qualitative palette is used instead (matches the strain-cluster palette
# approach in scripts/_notrack/01_bac_taxonomy_sanger_16S/03_tree_summary_table.qmd).
make_palette <- function(categories, seed = 42) {
  n <- length(categories)

  if (n <= 12) {
    cols <- RColorBrewer::brewer.pal(max(n, 3), "Paired")[seq_len(n)]
  } else {
    set.seed(seed)
    cols <- unname(Polychrome::createPalette(
      n,
      seedcolors = c("#2E91E5", "#E15F99", "#1CA71C")
    ))
  }

  rlang::set_names(cols, categories)
}
