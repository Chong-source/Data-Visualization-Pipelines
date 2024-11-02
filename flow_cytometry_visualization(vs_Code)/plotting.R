library(ggplot2)
library(tidyverse)

# Insert your file name here:
csv_data_original <- read.csv(file = "data.csv")
gfp <- read.csv(file = "gfp_data_grouped.csv")
mscarlet <- read.csv(file = "ymScarlet_data_grouped.csv")
ungrouped_gfp <- read.csv(file = "gfp_data_ungrouped.csv")
ungrouped_mscarlet <- read.csv(file = "ymScarlet_data_ungrouped.csv")
gfpSignalOverNoise_data <- read.csv(file = "gfp_signal_over_noise.csv")

# gfpGrouped
gfp$QC.EX.light.dark <- factor(gfp$QC.EX.light.dark, 
                                levels = c("QC Dark", "QC Light", "EX Dark", "EX Light"))

gfpGrouped <- ggplot(gfp, aes(fill = QC.EX.light.dark, y = value, x = gene_name)) + 
  geom_bar(position = "dodge", stat = "identity") + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4", "#c561ff", "#00BA38"), 
                    labels = c("QCDark", "QCLight", "EX Dark", "EX ight")) +
  labs(title = 'gfpGrouped', y = 'GFP Fluorescence (A.U.)', fill = "Condition") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

gfpGrouped

# gfpUngrouped
gfpUngrouped <- ggplot(ungrouped_gfp, aes(fill=QC.EX.light.dark, y=value, x=gene_name)) + 
  geom_bar(position="dodge", stat="identity") +
  labs(title='gfpUngrouped', y='GFP Fluorescence (A.U.)') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

gfpUngrouped

# ymScarletGrouped
mscarlet$QC.EX.light.dark <- factor(gfp$QC.EX.light.dark, 
                                levels = c("QC Dark", "QC Light", "EX Dark", "EX Light"))

mscarletGrouped <- ggplot(mscarlet, aes(fill=QC.EX.light.dark, y=value, x=gene_name)) + 
  geom_bar(position="dodge", stat="identity") +
  scale_fill_manual(values = c("#F8766D", "#00BFC4", "#c561ff", "#00BA38"), 
                    labels = c("QCDark", "QCLight", "EX Dark", "EX ight")) +
  labs(title='mScarletGrouped', y='mScarlet Fluorescence (A.U.)', fill = "Condition") + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

mscarletGrouped

# ymScarletUngrouped
mscarletUngrouped <- ggplot(ungrouped_mscarlet, aes(fill=QC.EX.light.dark, y=value, x=gene_name)) + 
  geom_bar(position="dodge", stat="identity") + 
  labs(title='mScarletUngrouped', y='mScarlet Fluorescence (A.U.)') + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

mscarletUngrouped

# gfpSignalOverNoise
gfpSignalOverNoise <- ggplot(gfpSignalOverNoise_data, aes(fill='orange', y=value, x=gene_name)) +
  geom_bar(position="dodge", stat="identity") + 
  labs(title='gfpSignalOverNoise', y='Signal Over Noise (ratio)') + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

gfpSignalOverNoise
