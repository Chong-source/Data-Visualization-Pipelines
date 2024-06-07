## Plots clade model dN/dS estimates by gene
## Last updated 20240607 by Chong

library(tidyverse)

dnds <- read.csv("Sample_Gene_Bank_with_types - Sheet1.csv")

# Transforms to wide format for plotting lines
dnds_line <- spread(dnds, key = Background_Foreground, value = dNdS)


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
    size=2.5) + 
  
	# Plots lines between dN/dS values
	geom_segment(
		data = dnds_line,
		colour = "#1952a8",
			aes(x = `Background `, 
				y = Gene_name, 
				xend = Foreground, 
				yend = Gene_name), 
			size=2.5) + labs(x = "\u03C9 (dN/dS)") +

  # Plots the dN/dS for both clades as points
  geom_point(
    data = dnds,
    aes(x=dNdS, 
        y=Gene_name, 
        fill=Background_Foreground),
    size=2.5, 
    shape = 21) + 
  scale_fill_manual(name="Background/Foreground", values=c("black", "white")) +
  scale_color_manual(name="Statistical Significance", values = c("#eeeeee","#bbbbbb"))+

  # Scales axis and sets the aesthetics for the chart
	scale_x_continuous(n.breaks = 6) +
	theme(axis.text.x = element_text(angle = 0, hjust = 0.5), 
		panel.background = element_rect(fill = "white"),
		# the background of the data, want to change to grey white if insignificant
		panel.grid.major = element_line(size = 3, colour = "white"), 
		panel.grid.minor.x = element_blank(),
		panel.grid.major.x = element_line(colour = "black",size = 0.3),
		axis.ticks.x = element_blank(),
		axis.ticks.y = element_blank(),
		axis.title.y = element_blank())

# Groups data by gene type
if (!(all(dnds_line$Gene_type == "na"))){
    graph +
    facet_grid(scales="free_y", space = "free_y", facets = Gene_type ~.)
}else{
    graph
}


