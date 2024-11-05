library(rvg)
library(dplyr)
library(officer)
library(ggplot2)
library(tidyverse)

# Insert your file name here:
csv_data_original <- read.csv(file = "data.csv")
gfp <- read.csv(file = "gfp_data_grouped.csv", row.names = NULL)
mscarlet <- read.csv(file = "ymScarlet_data_grouped.csv", row.names = NULL)
ungrouped_gfp <- read.csv(file = "gfp_data_ungrouped.csv", row.names = NULL)
ungrouped_mscarlet <- read.csv(file = "ymScarlet_data_ungrouped.csv", row.names = NULL)
gfpSignalOverNoise_data <- read.csv(file = "gfp_signal_over_noise.csv", row.names = NULL)

# gfpGrouped
gfp$QC.EX.light.dark <- factor(gfp$QC.EX.light.dark, 
                                levels = c("QC Dark", "QC Light", "EX Dark", "EX Light"))

gfpGrouped <- ggplot(gfp, aes(fill = QC.EX.light.dark, y = value, x = gene_name)) + 
  geom_bar(position = "dodge", stat = "identity") + 
  geom_errorbar(aes(ymin = value - stdev, ymax = value + stdev), 
  width = 0.25, position = position_dodge(0.9)) +
  scale_fill_manual(values = c("#F8766D", "#00BFC4", "#c561ff", "#00BA38"), 
                    labels = c("QCDark", "QCLight", "EX Dark", "EX ight")) +
  labs(title = 'gfpGrouped', y = 'GFP Fluorescence (A.U.)', fill = "Condition") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

gfpGrouped
# ggsave("gfpGrouped.png", plot = gfpGrouped, width = 10, height = 7)

# gfpUngrouped
gfpUngrouped <- ggplot(ungrouped_gfp, aes(fill=QC.EX.light.dark, y=value, x=gene_name)) + 
  geom_bar(position="dodge", stat="identity") +
  geom_errorbar(aes(ymin = value - stdev, ymax = value + stdev), 
  width = 0.25, position = position_dodge(0.9)) +
  labs(title='gfpUngrouped', y='GFP Fluorescence (A.U.)') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

gfpUngrouped

# ymScarletGrouped
mscarlet$QC.EX.light.dark <- factor(gfp$QC.EX.light.dark, 
                                levels = c("QC Dark", "QC Light", "EX Dark", "EX Light"))

mscarletGrouped <- ggplot(mscarlet, aes(fill=QC.EX.light.dark, y=value, x=gene_name)) + 
  geom_bar(position="dodge", stat="identity") +
  geom_errorbar(aes(ymin = value - stdev, ymax = value + stdev), 
  width = 0.25, position = position_dodge(0.9)) +
  scale_fill_manual(values = c("#F8766D", "#00BFC4", "#c561ff", "#00BA38"), 
                    labels = c("QCDark", "QCLight", "EX Dark", "EX ight")) +
  labs(title='mScarletGrouped', y='mScarlet Fluorescence (A.U.)', fill = "Condition") + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
mscarletGrouped

# ymScarletUngrouped
mscarletUngrouped <- ggplot(ungrouped_mscarlet, aes(fill=QC.EX.light.dark, y=value, x=gene_name)) + 
  geom_bar(position="dodge", stat="identity") + 
  geom_errorbar(aes(ymin = value - stdev, ymax = value + stdev), 
  width = 0.25, position = position_dodge(0.9)) +
  labs(title='mScarletUngrouped', y='mScarlet Fluorescence (A.U.)') + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

mscarletUngrouped

# gfpSignalOverNoise
gfpSignalOverNoise <- ggplot(gfpSignalOverNoise_data, aes(fill='orange', y=value, x=gene_name)) +
  geom_bar(position="dodge", stat="identity") + 
  geom_errorbar(aes(ymin = value - stdev, ymax = value + stdev), 
  width = 0.25, position = position_dodge(0.9)) +
  labs(title='gfpSignalOverNoise', y='Signal Over Noise (ratio)') + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

gfpSignalOverNoise

# Initialize PowerPoint
my_ppt <- read_pptx()

# Slide 1: gfpGrouped
my_ppt <- my_ppt %>%
  add_slide(layout = "Title and Content", master = "Office Theme") %>%
  ph_with(dml(ggobj = gfpGrouped), location = ph_location_type(type = "body"))

# Slide 2: gfpUngrouped
my_ppt <- my_ppt %>%
  add_slide(layout = "Title and Content", master = "Office Theme") %>%
  ph_with(dml(ggobj = gfpUngrouped), location = ph_location_type(type = "body"))

# Slide 3: mscarletGrouped
my_ppt <- my_ppt %>%
  add_slide(layout = "Title and Content", master = "Office Theme") %>%
  ph_with(dml(ggobj = mscarletGrouped), location = ph_location_type(type = "body"))

# Slide 4: mscarletUngrouped
my_ppt <- my_ppt %>%
  add_slide(layout = "Title and Content", master = "Office Theme") %>%
  ph_with(dml(ggobj = mscarletUngrouped), location = ph_location_type(type = "body"))

# Slide 5: gfpSignalOverNoise
my_ppt <- my_ppt %>%
  add_slide(layout = "Title and Content", master = "Office Theme") %>%
  ph_with(dml(ggobj = gfpSignalOverNoise), location = ph_location_type(type = "body"))

# Save the PowerPoint file
print(my_ppt, target = "flow_cytometry_graphs_success.pptx")
