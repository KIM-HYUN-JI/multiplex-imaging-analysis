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

# Four synthetic cell populations are created solely for demonstration.
population <- sample(
  c("Population_A", "Population_B", "Population_C", "Population_D"),
  n_cells,
  replace = TRUE
)

# ------------------------------------------------------------------------------
# Simulate cell-level data
# ------------------------------------------------------------------------------

synthetic_data <- data.frame(
  cell_id = paste0("Cell_", seq_len(n_cells)),
  sample_id = sample(sample_ids, n_cells, replace = TRUE),
  group = sample(groups, n_cells, replace = TRUE),
  true_population = population,

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

  x_coord = runif(n_cells, 0, 1000),
  y_coord = runif(n_cells, 0, 1000)
)

# ------------------------------------------------------------------------------
# Generate population-specific marker profiles
# ------------------------------------------------------------------------------

synthetic_data$marker_1 <- ifelse(
  population == "Population_A",
  rgamma(n_cells, shape = 6, scale = 2),
  rgamma(n_cells, shape = 2, scale = 1)
)

synthetic_data$marker_2 <- ifelse(
  population == "Population_B",
  rgamma(n_cells, shape = 6, scale = 2),
  rgamma(n_cells, shape = 2, scale = 1)
)

synthetic_data$marker_3 <- ifelse(
  population == "Population_C",
  rgamma(n_cells, shape = 6, scale = 2),
  rgamma(n_cells, shape = 2, scale = 1)
)

synthetic_data$marker_4 <- ifelse(
  population == "Population_D",
  rgamma(n_cells, shape = 6, scale = 2),
  rgamma(n_cells, shape = 2, scale = 1)
)

# ------------------------------------------------------------------------------
# Introduce synthetic QC failures
# ------------------------------------------------------------------------------

bad_area_cells <- sample(seq_len(n_cells), 80)

synthetic_data$cell_area[bad_area_cells] <- runif(
  length(bad_area_cells),
  min = 5,
  max = 20
)

bad_marker_cells <- sample(
  setdiff(seq_len(n_cells), bad_area_cells),
  80
)

synthetic_data$qc_marker[bad_marker_cells] <- runif(
  length(bad_marker_cells),
  min = -2,
  max = -0.1
)

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
