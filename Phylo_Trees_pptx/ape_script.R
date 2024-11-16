
# installs treeio if not already installed
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("treeio")

install.packages("ape")

## LIBRARIES
library(ape)
library(treeio)

########################## READ THIS FIRST #####################################
# The file containing the tree to be displayed must be in nexus format. Any
# AA transition annotations must be done in FigTree, with the annotation
# category titled "AAsub". If the default settings do not produce the desired
# tree, they can be altered by changing the constants below. Run every line of
# code from the beginning, including the constants and functions, up until the
# end.

############################# CONSTANTS ########################################
FILE_LOCATION <- "C:/Users/tonyx/Downloads/nexus_test2"
SPECIES_NAME_FONT_SIZE <- 0.6
# PHYLOGENETIC DISTANCE LABELS ========================
CUTOFF <- 0.03
DECIMALS <- 2
# FORMATTING ==========================================
BRANCH_ANNOTATION_FONT_SIZE <- 0.45
PHYLOGENETIC_DISTANCE_HORIZONTAL_SHIFT <- 1
AA_TRANSITION_HORIZONTAL_SHIFT <- 1.2
PHYLOGENETIC_DISTANCE_VERTICAL_SHIFT <- -0.45 # the more negative, the more upwards

############################# FUNCTIONS ########################################

extract_nexus_line <- function(file_location){
  
  # Takes the location of the nexus file as an argument, and extracts the line 
  # containing the tree info from it
  
  treefile <- file(file_location, "r")
  for (i in 1:3){
    line <- readLines(treefile, n = 1)
  }
  close(treefile)
  
  
  counter <- 1
  while (substr(line, counter, counter) != "("){
    counter <- counter + 1
  }
  line <- substr(line, counter, nchar(line))
  
  return (line)
}


comma_to_colon <- function(text){
  
  # Changes all of the commas in a particular piece of text to colons. Necessary
  # to convert an NEXUS file with annotations to NHX
  
  colon_string <- ""
  for (i in 1:nchar(text)){
    if (substr(text, i, i) == ","){
      colon_string <- paste(colon_string, ":", sep="")
    }
    else{
      colon_string <- paste(colon_string, substr(text, i, i), 
                            sep="")
    }
  }
  return (colon_string)
}

nexus_to_nhx_text <- function(line){
  
  # Converts a nexus file to nhx by changing the formatting of the annotations.
  # EXAMPLE OF NHX FILE FORMAT:
  #
  # treetext = "(ADH2:0.1[&&NHX:S=human], ADH1:0.11[&&NHX:S=human]):0.05;"
  #
  # Main difference is simply moving the annotation from beside the node to 
  # beside the phylogenetic distance
  
  counter <- 1
  annotation_storage <- ""
  nhx_file <- ""
  start <- 1
  
  ch <- substr(line, counter, counter)
  while (ch != ""){
    
    # has found the beginning of a nexus annotation
    if (ch == "["){
      
      nhx_file <- paste(nhx_file, substr(line, start, counter - 1), sep="")
      counter <- counter + 2 
      start <- counter
      ch <- substr(line, counter, counter)
      
      while (ch != "]"){
        counter <- counter + 1
        ch <- substr(line, counter, counter) 
      }
      
      # has found the end of the annotation, and extracts it
      annotation_storage <- comma_to_colon(substr(line, start, counter - 1))
      
      counter <- counter + 1
      start <- counter
      
      # finds the "end" of the branch distance
      while (ch != "," && ch != ";" && ch != ")"){
        counter <- counter + 1
        ch <- substr(line, counter, counter)
      }
      
      
      # appends the annotation to the end of the branch distance
      nhx_file <- paste(nhx_file, substr(line, start, counter - 1), sep="")
      annotation_storage <- paste("[&&NHX:", annotation_storage, "]", sep="")
      nhx_file <- paste(nhx_file, annotation_storage, sep="")
      
      start <- counter
    }
    
    # iterates through the whole file
    else{
      
      counter <- counter + 1 
      ch <- substr(line, counter, counter)
      
    }
    
  }
  
  nhx_file <- paste(nhx_file, substr(line, start, counter - 1), sep="")
  print(nhx_file)
  
  return (nhx_file)
}

organize_phylogenetic_distances <- function(edge_lengths, cutoff, decimals){
  
  # takes the default tree edge data as input, then formats it into readable
  # phylogenetic distance data
  
  # counts the number of labels to include
  count_over <- 0
  for (i in 1:length(edge_lengths)){
    if (edge_lengths[i] > cutoff){
      count_over <- count_over + 1
    }
  }
  
  # decimal and size cutoff
  counter <- 1
  new_lengths <- rep("", count_over)
  positions <- rep(0, count_over)
  for (i in 1:length(edge_lengths)){
    if (edge_lengths[i] > cutoff){
      new_lengths[counter] <- format(round(edge_lengths[i],decimals), nsmall = decimals)
      positions[counter] <- i
      counter <- counter + 1
    }
  }
  
  print(length(new_lengths))
  print(length(positions))
  
  data <- cbind.data.frame(new_lengths, positions)
  
  return (data)
}

organize_AA_transitions <- function(data){
  
  # takes the default tree data as input, then formats it into AA transition 
  # data available for display
  
  count_over <- 0
  for (i in 1:length(data$AAsub)){
    if (!is.na(data$AAsub[i])){
      count_over <- count_over + 1
    }
  }
  
  counter <- 1
  new_lengths <- rep("", count_over)
  positions <- rep(0, count_over)
  for (i in 1:length(data$AAsub)){
    if (!is.na(tree@data$AAsub[i])){
      new_lengths[counter] <- data$AAsub[i]
      positions[counter] <- data$node[i]
      counter <- counter + 1
    }
  }
  
  return (cbind.data.frame(new_lengths, positions))
}

# extracts the tree from the nexus file, converts it into an R tree
line <- extract_nexus_line(FILE_LOCATION)
nhx_file <- nexus_to_nhx_text(line)
tree <- read.nhx(textConnection(nhx_file))

# creates the skeleton plot without branch labelling
plot(tree@phylo, cex = SPECIES_NAME_FONT_SIZE)

# obtains formatted phylogenetic distances
phylo_distances <- organize_phylogenetic_distances(tree@phylo$edge.length,
                                                   cutoff = CUTOFF, 
                                                   decimals = DECIMALS)

# adds phylogenetic distance labels to the skeleton plot
edgelabels(phylo_distances$new_lengths, phylo_distances$positions, 
           adj = c(PHYLOGENETIC_DISTANCE_HORIZONTAL_SHIFT, PHYLOGENETIC_DISTANCE_VERTICAL_SHIFT), 
           cex = BRANCH_ANNOTATION_FONT_SIZE, frame = "n")

# adds AA transition data (if it exists)
if (!is.null(tree@data$AAsub)){
  AA_transitions <- organize_AA_transitions(tree@data)
  nodelabels(AA_transitions$new_lengths, AA_transitions$positions, 
             frame = "r", adj = c(AA_TRANSITION_HORIZONTAL_SHIFT), cex = BRANCH_ANNOTATION_FONT_SIZE)
  
}



