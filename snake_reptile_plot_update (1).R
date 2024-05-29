## Plots clade model dN/dS estimates by gene
## Last updated 20220523 by avn

library(tidyverse)

dnds <- read.csv("Snake_Reptile_CmC (1).csv")

# Transforms to wide format for plotting lines
dnds_line <- spread(dnds, key = Clade, value = dNdS)

## Randomly Generated data from differences in Reptile and Snack Genes
## To show significance
sequence <- vector(mode = 'list', length = length(dnds_line$Gene_name))
reptile_col <- dnds_line$Reptile
snake_col <- dnds_line$Snake
new_col <- c()
for (i in 1:length(snake_col)){
  if (is.na(snake_col[i]) || is.na(reptile_col[i])){
    new_col <- c(new_col, "insignificant")
  }
  else{
    if (abs(snake_col[i] - reptile_col[i]) > 0.31){
      new_col <- c(new_col, "significant")
    }
  }
}
dnds_line$Absolute_Diff <- new_col


## Plots the dN/dS values for each clade by gene and grouped by photoreceptor class
ggplot() +
  
  # Overlay a segment graph as a background to represent significance 
  geom_segment(
    data = dnds_line,
    aes(x = rep(-Inf, length(Gene_name)), 
        y = Gene_name, 
        xend = rep(Inf, length(Gene_name)), 
        yend = Gene_name, 
        colour = Absolute_Diff), 
    size=2.5) +
  
	# Plots lines between dN/dS values
	geom_segment(
		data = dnds_line,
			aes(x = Reptile, 
				y = Gene_name, 
				xend = Snake, 
				yend = Gene_name, 
				colour = Photoreceptor), 
			size=2.5) + labs(x = "\u03C9 (dN/dS)") +

  # Plots the dN/dS for both clades as points
  geom_point(
    data = dnds,
    aes(x=dNdS, 
        y=Gene_name, 
        fill=Clade),
    size=2.5, 
    shape = 21) +
  
	# Colour scheme for the different photoreceptor classes
	scale_color_manual(values=c('red', 'green', '#DCDCDC', 'blue', '#808080')) +
	# Coloiur scheme for the background and foreground dN/dS
	scale_fill_manual(values=c('white','black')) +
	# Groups data by photoreceptor class
  facet_grid(scales="free_y", space = "free_y", facets = Photoreceptor ~.) +
  # Scales axis and sets the aesthetics for the chart
	scale_x_continuous(n.breaks = 6) +
	theme(axis.text.x = element_text(angle = 0, hjust = 0.5), 
		panel.background = element_rect(fill = "white"),
		# the background of the data, want to change to grey white if insignificant
		panel.grid.major = element_line(size = 3, colour = "white"), 
		panel.grid.minor.x = element_blank(),
		panel.grid.major.x = element_line(colour = "black",size = 0.5),
		axis.ticks.x = element_blank(),
		axis.ticks.y = element_blank(),
		axis.title.y = element_blank())



