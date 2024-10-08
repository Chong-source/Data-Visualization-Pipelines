library(ggplot2)
library(tidyverse)
# Insert your file name here:
csv_data <- read.csv(file = "2022-08-17.csv")
col_names <- colnames(csv_data)
# Changing the commas into decimal points from Flowjo
# Only changing columns 2 and 3
csv_data[, 2:3] <- lapply(csv_data[, 2:3], function(x) {
  if (is.character(x)) {
    as.numeric(gsub(",", ".", x))
  } else {
    x
  }
})

# Creating data frame for GFP - Ungrouped

