## Plots clade model dN/dS estimates by gene
## Last updated 20240719 by Chong

## rvg allows you to convert R objects into vectors that 
## pptx can understand. The officer package allows manipulation 
## of MS Files from the R interface.

# If you don't have these packages, un-comment the following lines to install
# install.packages("tidyverse")
# install.packages("rvg")
# install.packages("dplyr")
# install.packages("ggplot2")
# install.packages("officer")
# install.packages("ggnewscale")
# install.packages("RColorBrewer")
# install.packages("forcats")

library(tidyverse)
library(rvg)
library(dplyr)
library(ggplot2)
library(officer)
library(ggnewscale)
library(RColorBrewer)

# Read the file into csv
dnds <- read.csv("SampleData_types_proportion.csv")

# Read in the ppt
my_ppt <- read_pptx('Template.pptx')

# Inefficient data processing
for(i in 1:length(dnds$Proportion)){
  value <- dnds$Proportion[i]
  if(value < 0.01){
    dnds$Proportion[i] <- '0.01 or less'
  } else if(value < 0.025){
    dnds$Proportion[i] <- '0.01-0.025'
  } else if(value < 0.05){
    dnds$Proportion[i] <- '0.025-0.05'
  } else if(value < 0.1){
    dnds$Proportion[i] <- '0.05-0.1'
  } else if(value < 0.2){
    dnds$Proportion[i] <- '0.1-0.2'
  } else if(value <= 0.5){
    dnds$Proportion[i] <- '0.2-0.5'
  } else{
    dnds$Proportion[i] <- '0.5 or greater'
  }
}

# Transforms to wide format for plotting lines
dnds_line <- dnds %>% 
  spread(key = Background_Foreground, value = dNdS) %>%
  mutate(Gene_name=fct_reorder(Gene_name, desc(Gene_name)))
# Note: You can make the labels in the y-axis reversed ordered if you remove 
# the mutate function

# Fixing the color bug where if all the data are insignificant
# because the color template has 2 colors, it will show as significant.
if(all(dnds_line$Statistical_Significance == "Yes")){
  color <- c("#bbbbbb")
} else if(all(dnds_line$Statistical_Significance == "No")){
  color <- c("#eeeeee")
} else{
  color <- c("#eeeeee","#bbbbbb")
}

# Getting the range for all data to set the max and the min of the axis
range_all_data <- c(dnds_line$Background, dnds_line$Foreground)

## Plots the dN/dS values for each clade by gene and grouped by photoreceptor class
graph <- ggplot() +
  
  # Overlay a segment graph as a background to represent significance 
  geom_segment(
    data = dnds_line,
    aes(x = rep(-Inf, length(Gene_name)), 
        y = Gene_name, 
        xend = rep(Inf, length(Gene_name)), 
        yend = Gene_name, 
        colour = Statistical_Significance), 
        linewidth=4,
        ) + 
  scale_color_manual(name="Statistical Significance", values = color) + 
  guides(colour="none")+
  
  # The function from the ggnewscale that allows R to have multiple manual 
  # scales for color
  new_scale_color()

# Choosing the different colours for the segments when they are of diff gene_types
if (!(all(dnds_line$Gene_type == "na"))){
  # gene_type_colours <- brewer.pal(length(levels(factor(dnds_line$Gene_type))),"Dark2")
  colours2 <- c("#1463ab","#df232a", "#626364","#AB5C14", 
                "#23DFD8", "#88DF23", "#7A23DF")
  gene_type_colours <- colours2[1:length(levels(factor(dnds_line$Gene_type)))]
  graph <- graph + 
    # Plots lines between dN/dS values
    # Two manual scale solutions: 
    # https://stackoverflow.com/questions/59391352/use-two-colour-scales-possible-with-work-around
    geom_segment(
      data = dnds_line,
      aes(
          colour = factor(Gene_type),
          x = Background, 
          y = Gene_name, 
          xend = Foreground, 
          yend = Gene_name), 
      linewidth=4) + labs(x = "\u03C9 (dN/dS)") +
    scale_colour_manual(name = "Gene Type", values = gene_type_colours) +
    
    # Adding breaks to the x-axis, for some reason, the breaks only contain the max
    # if you set the limits for scale_x_continuous
    scale_x_continuous(n.breaks = 10, limits = c(floor(min(range_all_data)), 
                                                 ceiling(max(range_all_data))))
}else{
  graph <- graph +
    geom_segment(
      colour = '#1952a8',
      data = dnds_line,
      aes(x = Background, 
          y = Gene_name, 
          xend = Foreground, 
          yend = Gene_name), 
      linewidth=4) + labs(x = "\u03C9 (dN/dS)") +
    scale_x_continuous(n.breaks = 10, limits = c(floor(min(range_all_data)), 
                                                 ceiling(max(range_all_data))))
}

graph <- graph +
  
  # Add Vertical lines to the graph
  # source: https://stackoverflow.com/questions/71569614/how-to-get-a-complete-vector-of-breaks-from-the-scale-of-a-plot-in-r
  geom_vline(
    xintercept = as.numeric(na.omit(layer_scales(graph)$x$break_positions())),
    color = "white",
    linewidth = 0.5
  ) + 
  
  # Plots the dN/dS for both clades as points
  geom_point(
    data = dnds,
    stroke = 1.2,
    shape = 21,
    aes(x=dNdS,
        y=Gene_name,
        fill=Background_Foreground,
        colour=Background_Foreground,
        size=ordered(Proportion))) + 
  scale_fill_manual(name="Background/Foreground", values=c("black", "white")) +
  scale_size_manual(name = "Proportion", values=c(3, 3.7, 4.2, 4.9, 5.6, 6.3, 7)) +
  scale_colour_manual(name='diff sizes', values = c("#1463ab","#df232a", "#626364","#AB5C14", 
                                                    "#23DFD8", "#88DF23", "#7A23DF"))+
  
  # Remove the colour guide
  guides(colour="none") +
  
  # Scales axis and sets the aesthetics for the chart
  theme(
    plot.background = element_blank(),
    plot.margin = unit(c(0, 0, 0, 70), "pt"),
    plot.title=element_text(size=15),
    panel.background = element_blank(),
    # the background of the data, want to change to grey white if insignificant
    panel.grid.major = element_blank(), 
    panel.grid.minor.x = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.ontop = FALSE,
    panel.spacing.y = unit(12, 'pt'),
    axis.ticks.x = element_line(color = "black", linewidth = 0.6),
    axis.line.x.bottom = element_line(colour = "black", linewidth =0.6),
    axis.ticks.y = element_blank(),
    axis.title.y = element_blank(),
    text = element_text(size=15),
    axis.text = element_text(size=13),
    axis.text.x = element_text(angle = 0, hjust = 0.5),
    axis.title.x = element_text(size=15, 
                                margin = margin(t = 15, r = 0, b = 0, l = 0)),
    legend.background = element_blank(),
    legend.box.background = element_blank(),
    legend.text=element_text(size=13),
    legend.title=element_text(size=15, margin = margin(b = 10)),
    legend.spacing.y = unit(20, 'pt'),
    legend.key.spacing.y = unit(10, "pt"))

if (!(all(dnds_line$Gene_type == "na"))){
  graph <- graph +
    facet_grid(scales="free_y", space = "free_y", rows = Gene_type ~.) 
  graph
}else{
  graph
}

## insert into ppt
my_ppt <- my_ppt %>% ph_with(dml(ggobj=graph),
                             location = ph_location_label(ph_label = 'R Placeholder'))
## save/download pptx
print(my_ppt, paste0('Presentation.pptx'))
