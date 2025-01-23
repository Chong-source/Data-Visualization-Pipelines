# Load necessary libraries
library(ggplot2)
library(dplyr)

# Read the data
gene_data <- read.csv("processed.csv")

# Create the bar plot
gene_plot <- ggplot(gene_data, aes(x = reorder(gene_name, light.dark), y = value, fill = light.dark)) +
  geom_bar(stat = "identity", position = position_dodge(), width = 0.7) +
  geom_errorbar(aes(ymin = value - stdev, ymax = value + stdev), 
                width = 0.2, position = position_dodge(0.7)) +
  scale_fill_manual(values = c("Dark" = "darkgrey", "Light" = "lightblue")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "Gene Name", y = "Value", fill = "Gene Group",
       title = "Bar Plot of Light and Dark Genes with Error Bars")

# Print the plot
print(gene_plot)
