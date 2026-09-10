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
