################################### OVERVIEW ###################################
# Given the files and specifications in the "USER INPUT" section, this script 
# generates a publication-ready figure of retinal release experimental data
# using the package "ggplot2". Up to four data sets can be displayed in the 
# same plot. For the fitted curves, first input each dataset separately into 
# "retinal_release_script.R", then enter the parameter values of the curves into 
# the "USER_INPUT" section.

################################## USER INPUTS ##################################

# ---------------------------------- GENERAL -----------------------------------

ggplot2_installed <- TRUE
# If ggplot2 has not been installed, change this to "FALSE" for the first
# running of the program, then "TRUE" afterwards to avoid multiple downloads. 

x_label <- "Time (min)"
# Change this to the desired x-axis label for the graph. The default is 
# "Time (min)"

y_label <- "Relative Fluorescence"
# Change this to the desired y-axis label for the graph. The default is 
# "Relative Fluorescence".

label_title_size <- 16
# The font size for the label titles

label_text_size <- 12
# The font size of the label numbers

is_line_graph <- FALSE
# Select TRUE if a line graph of the raw data points is desired. Otherwise, if 
# if a scatter plot is desired, select FALSE

point_size <- 1.5
# size of the data points on the plot, IF it is a scatter plot

# ---------------------------------- LEGEND ------------------------------------

include_legend <- FALSE
# Change this to FALSE if a legend is not desired

legend_title <- "Label"
# Change this to the desired legend title

dataset_1_label <- "I11"
dataset_2_label <- "I16C"
dataset_3_label <- "Zebrafish"
dataset_4_label <- "Bovine"
# Change these to the desired legend labels. If a dataset is not present,
# change its label to ""

legend_title_size <- 12
legend_font_size <- 10
# font sizes of the legend title and labels, respectively


# --------------------------- VERTICAL DASHED LINES ----------------------------

vertical_dashed_line_indicating_curve_start <- TRUE
# Keep this as TRUE, if you would like a dashed line indicating the start time of
# the reaction. Otherwise, set this as FALSE

multiple_dashed_lines <- FALSE
# Change this to TRUE, if you would like dashed lines for each dataset

dashed_line_width <- 0.75
# width of the dashed line


# --------------------------- GENERAL FITTED CURVES ----------------------------

curve_line_width <- 0.75
# line width of the fitted curves


# ----------------------------- HALF-LIFE DISPLAY ------------------------------

include_half_life_display <- TRUE
# Change this to FALSE if you would not like a text display of the half-lives
# for each dataset. 

customize_half_life_labels <- FALSE
# select TRUE if you would like to change the half-life labels (to include 
# standard error bars, etc.)

customized_half_life_1 <- "T1/2 = custom1"
customized_half_life_2 <- "T1/2 = custom2"
customized_half_life_3 <- "T1/2 = custom3"
customized_half_life_4 <- "T1/2 = custom4"
# If custom half-life labels are desired, enter them in for their respective 
# data sets here

half_life_text_size <- 6
# the font size of the half life display text. Note that these are in different 
# units than the label fonts. 

half_life_vertical_floor <- 0.02
# the y-axis position for the bottom of the half-life display text

half_life_text_spacing_between_datasets <- 0.065
# the y-axis spacing between stacked half-life display texts

horizontal_position <- 0.72
# THe horizontal position of the display. Scales from 0 (all the way to the 
# left) to 1 (all the way on the right)


# ------------------------------ FIRST DATASET ---------------------------------

file_location_1 <- "rrtest1.csv"
# Change this to the CSV file containing the data for the first dataset.

y0 <- 0.145754
a <- 0.834408
k <- 0.071380
# Parameters of the fitted curve of the first dataset, as obtained via the 
# retinal_release script


first_curve_first_point <- 12
# Change this to the first point that encompasses the curve for the first 
# dataset. For example, enter "5" if the fifth point in the dataset is the first 
# point that the curve encompasses. 

colour_1 <- "black"
# colour of the raw data points for the first dataset.

line_colour_1 <- "black"
# colour of the fitted curve


# ----------------------------- SECOND DATASET ---------------------- (optional)

file_location_2 <- ""
# Change this to the CSV file containing the data for the second dataset.
# If there is no second dataset, please set this to "", otherwise errors will
# occur. 

y0_2 <- 0.048390
a_2 <- 0.931124
k_2 <- 0.112375
# Change this to the parameters of the fitted curve of the second dataset, as 
# obtained via the retinal_release script


second_curve_first_point <- 11
# Change this to the first point that encompasses the curve for the second 
# dataset. For example, enter "5" if the fifth point in the dataset is the first 
# point that the curve encompasses. 

colour_2 <- "#55AD89"
# colour of the raw data points for the second dataset.

line_colour_2 <- "#55AD89"
# colour of the fitted curve

# ------------------------------ THIRD DATASET ---------------------- (optional)

file_location_3 <- ""
# C:/Users/tonyx/Downloads/zf_RR.csv
# Change this to the CSV file containing the data for the third dataset
# If there is no third dataset, please set this to "", otherwise errors will
# occur.

y0_3 <- -0.023938
a_3 <- 1.026028 
k_3 <- 0.106457
# Change this to the parameters of the fitted curve of the third dataset, as 
# obtained via the retinal_release script


third_curve_first_point <- 1
# Change this to the first point that encompasses the curve for the third
# dataset. For example, enter "5" if the fifth point in the dataset is the first 
# point that the curve encompasses. 

colour_3 <- "#1170AA"
# colour of the raw data points for the third dataset.

line_colour_3 <- "#1170AA"
# colour of the fitted curve

# ----------------------------- FOURTH DATASET ---------------------- (optional)

file_location_4 <- ""
# Change this to the CSV file containing the data for the fourth dataset
# If there is no fourth dataset, please set this to "", otherwise errors will
# occur.

y0_4 <- -0.0157269
a_4 <- 1.1087347 
k_4 <- 0.0515216
# Change this to the parameters of the fitted curve of the fourth dataset, as 
# obtained via the retinal_release script


fourth_curve_first_point <- 4
# Change this to the first point that encompasses the curve for the fourth
# dataset. For example, enter "5" if the fifth point in the dataset is the first 
# point that the curve encompasses. 

colour_4 <- "red"
# colour of the raw data points for the fourth dataset.

line_colour_4 <- "red"
# colour of the fitted curve

################################### PROGRAM ####################################

# install ggplot2 if not already installed
if (!ggplot2_installed){
  install.packages("ggplot2") 
}

# The program uses ggplot2 to make the figure.
library(ggplot2)

# concatenates the file locations into one vector to iterate on later
file_locations <- c(file_location_1, file_location_2, file_location_3, file_location_4)

# counts the number of datasets the user added, depending on whether the file
# locations are left blank
num_datasets = 0
for (i in 1:4){
  if (file_locations[i] != ""){
    num_datasets <- num_datasets + 1
  }
  else{
    break
  }
}

# concatenates the user-specified curve parameters into a dataframe
curve_parameters <- data.frame(y0 = c(y0, y0_2, y0_3, y0_4), 
                               a = c(a, a_2, a_3, a_4),
                               k = c(k, k_2, k_3, k_4))

# concatenates the indices of the first datapoints that each curve encompasses
time_starts <- c(first_curve_first_point, 
                 second_curve_first_point, 
                 third_curve_first_point,
                 fourth_curve_first_point)

# concatenates the user-specified colours
cols <- c(colour_1, colour_2, colour_3, colour_4)[1:num_datasets]
legend_labels <- c(dataset_1_label, dataset_2_label, dataset_3_label, dataset_4_label)[1:num_datasets]
line_cols <- c(line_colour_1, line_colour_2, line_colour_3, line_colour_4)[1:num_datasets]


# reads each data file, normalizes them, then concatenates all the data into a 
# single list
datasets <- list()
for (i in 1:num_datasets){
  df <- read.csv(file_locations[i])
  colnames(df) <- c("Time", "Fluorescence")
  df$Fluorescence <- df$Fluorescence/max(df$Fluorescence)
  df["Group"] <- rep(as.character(i), length(df$Time))
  datasets <- c(datasets, list(df))
}

# finds the rightmost timepoint of the data
time_maximum <- 0
for (i in 1:num_datasets){
  times <- datasets[[i]]$Time
  if (times[length(times)] > time_maximum){
    time_maximum <- times[length(times)]
  }
}

# determines the half-life of each curve and stores them in a vector
half_lives <- c()
for (i in 1:num_datasets){
  half_lives <- append(half_lives, 
                       format(round(log(2)/curve_parameters$k[i], 2), nsmall = 2))
}

# generates data to plot each curve based on the user-specified parameters
curves <- list()
for (i in 1:num_datasets){
  dataset <- datasets[[i]]
  curve_time_start <- dataset$Time[time_starts[i]]
  X1 <- curve_time_start:ceiling(dataset$Time[length(dataset$Time)])
  Y1 <- curve_parameters$y0[i] + curve_parameters$a[i] * (1 - exp(-1 * curve_parameters$k[i] * (X1 - curve_time_start)))
  curves <- c(curves, list(data.frame(X1, Y1)))
}

# the dataframe that ggplot will refer to when plotting the data. 
presentation_df <- datasets[[1]]

# append the second and third datasets (if applicable) to the first to create
# combined dataframe to plot in one graph
i <- 2
while (i <= num_datasets){
  presentation_df <- rbind(presentation_df, datasets[[i]])
  i =  i + 1
}

# gpplot call
first_data <- ggplot(presentation_df, aes(x = Time, y = Fluorescence, color = Group)) + 
  # instantiates a scatter plot and the size of each point
  # sets the colours to the user-specified ones
  scale_color_manual(labels = legend_labels, values = cols) +
  # theme classic sets the white background
  theme_classic() + 
  # generates the rectangular border around the ground
  theme(panel.background = element_rect(colour = "black", linewidth = 1.5)) +
  # corrects the size of the axis titles and text
  theme(axis.title = element_text(size = label_title_size), 
        axis.text = element_text(size = label_text_size)) +
  # changes the x-axis title
  xlab(paste(x_label)) +
  # changes the y-axis title
  ylab(paste(y_label)) +
  # positions the y-axis title
  theme(axis.title.y = element_text(margin = margin(t = 0, r = 15, b = 0, l = 0))) +
  # positions the x-axis title
  theme(axis.title.x = element_text(margin = margin(t = 7, r = 0, b = 0, l = 0)))

if (is_line_graph){
  # graphs a line graph
  first_data <- first_data + geom_line()
} else{
  # otherwise, the raw data is displayed as points.
  first_data <- first_data + geom_point(size = point_size)
}


# plots each curve
for (i in 1:num_datasets){
  first_data <- first_data +
    geom_line(data = curves[[i]], aes(x = X1, y = Y1), linewidth = curve_line_width, color = line_cols[i])
} 

# plots the vertical dashed lines
if (vertical_dashed_line_indicating_curve_start){
  first_data <- first_data + 
    geom_vline(xintercept = datasets[[1]]$Time[time_starts[1]], 
               linewidth = dashed_line_width, linetype = 2, color = cols[1])
  if (multiple_dashed_lines){
    for (i in 2:num_datasets){
      first_data <- first_data +
        geom_vline(xintercept = datasets[[i]]$Time[time_starts[i]], 
                   linewidth = dashed_line_width, linetype = 2, color = cols[i])
    }
  }
}

custom_half_lives <- c(customized_half_life_1, 
                       customized_half_life_2, 
                       customized_half_life_3, 
                       customized_half_life_4)

if (include_half_life_display){
  
  # variables for the text listing the half-lives in the bottom right
  text_spacing_increment <- half_life_text_spacing_between_datasets
  vertical_position <- half_life_vertical_floor
  horizontal_position <- horizontal_position*time_maximum
  
  for (i in 1:num_datasets){
    if (!customize_half_life_labels){
      first_data <- first_data +
        annotate("text", x = horizontal_position, y = vertical_position,
                 label = paste("T1/2 =", half_lives[i]), size = half_life_text_size, color = line_cols[i],
                 hjust = 0)
    }
    else{
      first_data <- first_data +
        annotate("text", x = horizontal_position, y = vertical_position,
                 label = custom_half_lives[i], size = half_life_text_size, color = line_cols[i],
                 hjust = 0)
    }
    
    vertical_position <- vertical_position + text_spacing_increment
  }
}

# legend parameters as specified by the user
if (!include_legend){
  first_data <- first_data + theme(legend.position = "none")
} else {
  first_data <- first_data + 
    guides(color = guide_legend(title = legend_title)) +
    theme(legend.text=element_text(size=legend_font_size)) +
    theme(legend.title=element_text(size=legend_title_size))
}


# displays the graph
first_data

#---------------------Half-life bar graph------------------------

bardata <- data.frame(t = half_lives, names = c("test1"))
bar_hl <- ggplot(data = bardata, aes(names)) + geom_bar()
bar_hl


