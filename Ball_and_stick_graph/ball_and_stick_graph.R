## Plots clade model dN/dS estimates by gene
## Last updated 20240607 by Chong

## rvg allows you to convert R objects into vectors that 
## pptx can understand. The officer package allows manipulation 
## of MS Files from the R interface.

library(tidyverse)
library(rvg)
library(dplyr)
library(ggplot2)
library(officer)

# Read the file into csv
dnds <- read.csv("SampleData_types.csv")

# Read in the ppt
my_ppt <- read_pptx('Template.pptx')

# Transforms to wide format for plotting lines
dnds_line <- spread(dnds, key = Background_Foreground, value = dNdS)

# Fixing the color bug
if(all(dnds_line$Statistical_Significance == "Yes")){
  color <- c("#bbbbbb")
} else if(all(dnds_line$Statistical_Significance == "No")){
  color <- c("#eeeeee")
} else{
  color <- c("#eeeeee","#bbbbbb")
}

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
    linewidth=4) + 
  
	# Plots lines between dN/dS values
	geom_segment(
		data = dnds_line,
		colour = "#1952a8",
			aes(x = Background, 
				y = Gene_name, 
				xend = Foreground, 
				yend = Gene_name), 
			linewidth=4) + labs(x = "\u03C9 (dN/dS)") +
  
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
    aes(x=dNdS,
        y=Gene_name,
        fill=Background_Foreground),
    size=4.3,
    shape = 21) + 
  scale_fill_manual(name="Background/Foreground", values=c("black", "white")) +
  scale_color_manual(name="Statistical Significance", values = color) + 
  
  # Scales axis and sets the aesthetics for the chart
	scale_x_continuous(n.breaks = 6) +
	theme(
	  axis.text.x = element_text(angle = 0, hjust = 0.5), 
	  panel.background = element_rect(fill = NA),
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
		axis.title.x = element_text(size=15, 
		                          margin = margin(t = 15, r = 0, b = 0, l = 0)),
		plot.title=element_text(size=15),
		legend.text=element_text(size=13),
		legend.title=element_text(size=15, margin = margin(b = 10)),
		legend.key.spacing.y = unit(10, "pt"),
		legend.spacing.y = unit(20, 'pt'),
		plot.margin = unit(c(0, 0, 0, 70), "pt")) +
  
  # Add more ticks to the graph
  scale_x_continuous(breaks = scales::pretty_breaks(n = 10))

# Groups data by gene type
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

