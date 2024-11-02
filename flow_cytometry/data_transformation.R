library(ggplot2)
library(tidyverse)

# Insert your file name here:
csv_data_original <- read.csv(file = "2022-08-17.csv")
gfp <- read.csv(file = "gfp_data_grouped.csv")
mscarlet <- read.csv(file = "ymScarlet_data_grouped.csv")
ungrouped_gfp <- read.csv(file = "gfp_data_ungrouped.csv")
ungrouped_mscarlet <- read.csv(file = "ymScarlet_data_ungrouped.csv")
gfpSignalOverNoise_data <- read.csv(file = "gfp_signal_over_noise.csv")

# gfpGrouped
gfpGrouped <- ggplot(gfp, aes(fill=QC.EX.light.dark, y=value, x=gene_name)) + 
  geom_bar(position="dodge", stat="identity") + 
  labs(title='gfpGrouped', y='GFP Fluorescence (A.U.)')

gfpGrouped

# gfpUngrouped
gfpUngrouped <- ggplot(ungrouped_gfp, aes(fill=QC.EX.light.dark, y=value, x=gene_name)) + 
  geom_bar(position="dodge", stat="identity") +
  labs(title='gfpUngrouped', y='GFP Fluorescence (A.U.)')

gfpUngrouped

# ymScarletGrouped
mscarletGrouped <- ggplot(mscarlet, aes(fill=QC.EX.light.dark, y=value, x=gene_name)) + 
  geom_bar(position="dodge", stat="identity") +
  labs(title='mScarletGrouped', y='mScarlet Fluorescence (A.U.)')

mscarletGrouped

# ymScarletUngrouped
mscarletUngrouped <- ggplot(ungrouped_mscarlet, aes(fill=QC.EX.light.dark, y=value, x=gene_name)) + 
  geom_bar(position="dodge", stat="identity") + 
  labs(title='mScarletUngrouped', y='mScarlet Fluorescence (A.U.)')

mscarletUngrouped

# gfpSignalOverNoise
gfpSignalOverNoise <- ggplot(gfpSignalOverNoise_data, aes(fill='orange', y=value, x=gene_name)) +
  geom_bar(position="dodge", stat="identity") + 
  labs(title='gfpSignalOverNoise', y='Signal Over Noise (ratio)')

gfpSignalOverNoise
