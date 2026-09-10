# ==============================================================================
# Cell-level quality control and preprocessing
# Multiplex tissue imaging analysis
# ==============================================================================

library(dplyr)

# ------------------------------------------------------------------------------
# Quality control
# ------------------------------------------------------------------------------

# Thresholds should be determined empirically from segmentation characteristics
# and the biological context of the dataset.

lower_area_threshold <- NA_real_
upper_area_threshold <- NA_real_
qc_marker_threshold  <- NA_real_

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
