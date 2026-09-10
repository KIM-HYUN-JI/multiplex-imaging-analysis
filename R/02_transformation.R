# ==============================================================================
# Intensity transformation
# Multiplex tissue imaging analysis
# ==============================================================================

library(dplyr)

# ------------------------------------------------------------------------------
# Load processed expression data
# ------------------------------------------------------------------------------

expression_data <- read.csv(
  "output/expression_data.csv",
  check.names = FALSE
)

# ------------------------------------------------------------------------------
# Define marker columns
# ------------------------------------------------------------------------------

marker_cols <- grep(
  "^marker_",
  names(expression_data),
  value = TRUE
)

# ------------------------------------------------------------------------------
# Apply asinh transformation
# ------------------------------------------------------------------------------

# Cofactor values should be selected based on signal characteristics
# and the measurement scale of the dataset.
#
# A generic example value is used here for demonstration purposes only.

asinh_cofactor <- 5

expression_transformed <- expression_data %>%
  mutate(
    across(
      all_of(marker_cols),
      ~ asinh(.x / asinh_cofactor),
      .names = "{.col}_asinh"
    )
  )

# ------------------------------------------------------------------------------
# Export transformed data
# ------------------------------------------------------------------------------

write.csv(
  expression_transformed,
  "output/expression_transformed.csv",
  row.names = FALSE
)
