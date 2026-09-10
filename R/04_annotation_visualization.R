# ==============================================================================
# Cluster annotation and visualization
# Multiplex tissue imaging analysis
# ==============================================================================

library(Spectre)
library(data.table)

# ------------------------------------------------------------------------------
# Load clustering results
# ------------------------------------------------------------------------------

clustered_data <- fread(
  "output/clustered_data.csv"
)

umap_data <- fread(
  "output/umap_data.csv"
)

# ------------------------------------------------------------------------------
# Define generic cluster annotations
# ------------------------------------------------------------------------------

# Cluster labels below are illustrative examples only.
# The original study-specific phenotype definitions are not included.

cluster_annotations <- data.table(
  FlowSOM_metacluster = c(1, 2, 3, 4),
  Population = c(
    "Population_A",
    "Population_B",
    "Population_C",
    "Population_D"
  )
)

# ------------------------------------------------------------------------------
# Add annotations to clustering results
# ------------------------------------------------------------------------------

clustered_annotated <- merge(
  clustered_data,
  cluster_annotations,
  by = "FlowSOM_metacluster",
  all.x = TRUE
)

umap_annotated <- merge(
  umap_data,
  cluster_annotations,
  by = "FlowSOM_metacluster",
  all.x = TRUE
)

# ------------------------------------------------------------------------------
# Identify transformed marker columns
# ------------------------------------------------------------------------------

marker_cols <- grep(
  "_asinh$",
  names(clustered_annotated),
  value = TRUE
)

# ------------------------------------------------------------------------------
# Aggregate marker expression by annotated population
# ------------------------------------------------------------------------------

population_expression <- do.aggregate(
  clustered_annotated,
  marker_cols,
  by = "Population"
)

# ------------------------------------------------------------------------------
# Generate visualizations
# ------------------------------------------------------------------------------

dir.create(
  "figures",
  showWarnings = FALSE
)

setwd("figures")

make.pheatmap(
  population_expression,
  "Population",
  plot.cols = marker_cols
)

make.colour.plot(
  umap_annotated,
  "UMAP_X",
  "UMAP_Y",
  "FlowSOM_metacluster",
  col.type = "factor",
  add.label = TRUE
)

make.colour.plot(
  umap_annotated,
  "UMAP_X",
  "UMAP_Y",
  "Population",
  col.type = "factor",
  add.label = TRUE
)

setwd("..")

# ------------------------------------------------------------------------------
# Export annotated results
# ------------------------------------------------------------------------------

fwrite(
  clustered_annotated,
  "output/clustered_annotated.csv"
)

fwrite(
  umap_annotated,
  "output/umap_annotated.csv"
)
