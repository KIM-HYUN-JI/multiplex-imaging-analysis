# ==============================================================================
# Unsupervised clustering and dimensionality reduction
# Multiplex tissue imaging analysis
# ==============================================================================

library(Spectre)
library(data.table)

# ------------------------------------------------------------------------------
# Load transformed expression data
# ------------------------------------------------------------------------------

expression_transformed <- fread(
  "output/expression_transformed.csv"
)

# ------------------------------------------------------------------------------
# Define transformed marker columns
# ------------------------------------------------------------------------------

clustering_cols <- grep(
  "_asinh$",
  names(expression_transformed),
  value = TRUE
)

# ------------------------------------------------------------------------------
# FlowSOM clustering
# ------------------------------------------------------------------------------

# The number of metaclusters should be determined based on data structure
# and biological interpretability.
#
# Automatic metaclustering is used here as a generic demonstration.

clustered_data <- run.flowsom(
  expression_transformed,
  clustering_cols,
  meta.k = 4
)

# ------------------------------------------------------------------------------
# Subsample for dimensionality reduction
# ------------------------------------------------------------------------------

# UMAP is calculated on a subset for computational efficiency.

set.seed(123)

n_cells_for_umap <- min(
  5000,
  nrow(clustered_data)
)

umap_data <- clustered_data[
  sample(.N, n_cells_for_umap)
]

# ------------------------------------------------------------------------------
# UMAP
# ------------------------------------------------------------------------------

umap_data <- run.umap(
  umap_data,
  clustering_cols
)

# ------------------------------------------------------------------------------
# Export results
# ------------------------------------------------------------------------------

fwrite(
  clustered_data,
  "output/clustered_data.csv"
)

fwrite(
  umap_data,
  "output/umap_data.csv"
)
