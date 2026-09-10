# ==============================================================================
# Generate synthetic cell-level multiplex imaging data
# Multiplex tissue imaging analysis
# ==============================================================================

set.seed(123)

# ------------------------------------------------------------------------------
# Simulation settings
# ------------------------------------------------------------------------------

n_cells <- 3000

sample_ids <- c("Sample_A", "Sample_B", "Sample_C")
groups <- c("Group_1", "Group_2")

# ------------------------------------------------------------------------------
# Simulate cell-level data
# ------------------------------------------------------------------------------

synthetic_data <- data.frame(
  cell_id = paste0("Cell_", seq_len(n_cells)),
  sample_id = sample(sample_ids, n_cells, replace = TRUE),
  group = sample(groups, n_cells, replace = TRUE),

  cell_area = rlnorm(
    n_cells,
    meanlog = log(150),
    sdlog = 0.35
  ),

  qc_marker = rnorm(
    n_cells,
    mean = 2,
    sd = 0.7
  ),

  marker_1 = rgamma(
    n_cells,
    shape = 2,
    scale = 2
  ),

  marker_2 = rgamma(
    n_cells,
    shape = 2.5,
    scale = 1.8
  ),

  marker_3 = rgamma(
    n_cells,
    shape = 3,
    scale = 1.5
  ),

  marker_4 = rgamma(
    n_cells,
    shape = 1.8,
    scale = 2.2
  ),

  x_coord = runif(
    n_cells,
    min = 0,
    max = 1000
  ),

  y_coord = runif(
    n_cells,
    min = 0,
    max = 1000
  )
)

# ------------------------------------------------------------------------------
# Introduce a small number of QC failures
# ------------------------------------------------------------------------------

synthetic_data$cell_area[
  sample(seq_len(n_cells), 80)
] <- runif(80, min = 5, max = 20)

synthetic_data$qc_marker[
  sample(seq_len(n_cells), 80)
] <- runif(80, min = -2, max = -0.1)

# ------------------------------------------------------------------------------
# Save synthetic input data
# ------------------------------------------------------------------------------

dir.create(
  "example_data",
  showWarnings = FALSE
)

write.csv(
  synthetic_data,
  "example_data/synthetic_cells.csv",
  row.names = FALSE
)
