# ==============================================================================
# Cell-level quality control and preprocessing
# Multiplex tissue imaging analysis
# ==============================================================================

library(dplyr)

# ------------------------------------------------------------------------------
# Load synthetic example data
# ------------------------------------------------------------------------------

raw_data <- read.csv(
  "example_data/synthetic_cells.csv",
  check.names = FALSE
)

# ------------------------------------------------------------------------------
# Quality control
# ------------------------------------------------------------------------------

# Example thresholds are illustrative only and do not represent
# the original study-specific QC settings.

lower_area_threshold <- 40
upper_area_threshold <- 400
qc_marker_threshold  <- 0

qc_data <- raw_data %>%
  filter(
    cell_area >= lower_area_threshold,
    cell_area <= upper_area_threshold,
    qc_marker >= qc_marker_threshold
  )

# ------------------------------------------------------------------------------
# Organize data for downstream analysis
# ------------------------------------------------------------------------------

# The exact column names used in the original study are not included here.
# Generic example names are used to demonstrate the workflow.

expression_data <- qc_data %>%
  select(
    cell_id,
    starts_with("marker_")
  )

spatial_data <- qc_data %>%
  select(
    cell_id,
    x_coord,
    y_coord
  )

metadata <- qc_data %>%
  select(
    cell_id,
    sample_id,
    group
  )

# ------------------------------------------------------------------------------
# Export processed tables
# ------------------------------------------------------------------------------

dir.create("output", showWarnings = FALSE)

write.csv(
  expression_data,
  "output/expression_data.csv",
  row.names = FALSE
)

write.csv(
  spatial_data,
  "output/spatial_data.csv",
  row.names = FALSE
)

write.csv(
  metadata,
  "output/metadata.csv",
  row.names = FALSE
)
