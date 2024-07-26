if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

# Install the packages
# BiocManager::install("treeio")
# BiocManager::install("ggtree")
# install.packages('rvg')
# install.packages('dplyr')
# install.packages('ggplot2')
# install.packages('officer')
library(rvg)
library(dplyr)
library(ggplot2)
library(officer)
########################## READ THIS FIRST #####################################
# The file containing the tree to be displayed must be in nexus format. Any
# AA transition annotations must be done in FigTree, with the annotation
# category titled "AAsub". If the default settings do not produce the desired
# tree, they can be altered by changing the constants below. Run every line of
# code from the beginning, including the constants and functions, up until the
# end.

########################## BEGIN CONSTANTS #####################################
# GENERAL CONSTANTS =======================================
FILE_LOCATION <- "nexus_test2"
SPECIES_NAME_FONT_SIZE <- 2.25 
# PHYLOGENETIC DISTANCE CONSTANTS =========================
DISPLAY_CUTOFF <- 0.03
DECIMALS <- 3
# BRANCH LABEL FORMATTING =================================
BRANCH_ANNOTATION_FONT_SIZE <- 1.75
BRANCH_ANNOTATION_VERTICAL_SHIFT <- 0.33
PHYLOGENETIC_DISTANCE_HORIZONTAL_SHIFT <- -0.005
AA_TRANSITION_HORIZONTAL_SHIFT <- -0.013
##########################  END CONSTANTS ###################################### 


## LIBRARIES
library(ggtree)
library(treeio)
library(rvg)
library(dplyr)
library(ggplot2)
library(officer)

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


organize_phylogenetic_distances <- function(edges, edge_lengths, total_nodes,
                                            cutoff, decimals){
  
  # converts the stored phylogenetic distances stored in the tree to a form that
  # is annotatable
  
  # orders the phylogenetic distances by node
  ordered_distances <- rep(0,total_nodes)
  for (i in 1:length(edge_lengths)){
    ordered_distances[edges$V2[i]] = edge_lengths[i]
  }
  
  # converts these distances to a string format that is displayable
  string_distances <- rep("", total_nodes)
  
  for (i in 1:total_nodes){
    if (ordered_distances[i] >= cutoff){
      string_distances[i] <- format(round(ordered_distances[i],decimals), nsmall = decimals)
    }
    else{
      string_distances[i] <- ""
    }
  }
  
  return (string_distances)
}


organize_AA_transitions <- function(AA_transitions, AA_node, total_nodes){
  
  # orders the AA_transitions by node
  ordered_transitions <- rep("", total_nodes)
  
  for (i in 1:length(AA_transitions)){
    if (!is.na(AA_transitions[i])){
      ordered_transitions[AA_node[i]] <- AA_transitions[i]
    }
  }
  
  return (ordered_transitions)
}

############################ MAIN PROGRAM ######################################

# extracts the nexus file, converts it to nhx, then reads it as a tree
line <- extract_nexus_line(FILE_LOCATION)
nhx_file <- nexus_to_nhx_text(line)
tree <- read.nhx(textConnection(nhx_file))

# get phylogenetic distance info
edges <- as.data.frame(tree@phylo$edge)
edge_lengths <- unlist(tree@phylo$edge.length)

total_nodes <- length(edge_lengths) + 1

# convert the phylogenetic distances to displayable format
string_distances <- organize_phylogenetic_distances(edges, edge_lengths, 
                                                  total_nodes, 
                                                  cutoff = DISPLAY_CUTOFF, 
                                                  decimals = DECIMALS)

# get AA transition info
if (!is.null(tree@data$AAsub)){
  AA_transitions <- unlist(tree@data$AAsub)
  AA_node <- unlist(tree@data$node)
  ordered_transitions <- organize_AA_transitions(AA_transitions, AA_node, total_nodes)
}


# display the tree with various settings controllable via changing the constants
# at the top
p <- ggtree(tree, ladderize = TRUE, right = TRUE)
p <- p + theme_tree2() + geom_tiplab(size = SPECIES_NAME_FONT_SIZE, family = "sans") + 
  theme(legend.position="none") + 
  geom_text(aes(x = branch, label = string_distances), 
            size = BRANCH_ANNOTATION_FONT_SIZE, 
            nudge_y = BRANCH_ANNOTATION_VERTICAL_SHIFT, 
            nudge_x = PHYLOGENETIC_DISTANCE_HORIZONTAL_SHIFT)

if (!is.null(tree@data$AAsub)){
  p <- p + geom_text(aes(label = ordered_transitions), 
            size = BRANCH_ANNOTATION_FONT_SIZE, 
            nudge_y = BRANCH_ANNOTATION_VERTICAL_SHIFT, 
            nudge_x = AA_TRANSITION_HORIZONTAL_SHIFT, 
            color = "red")
}
p

########################## pptx presentation ###################################
my_ppt <- read_pptx('ppt_phylo_graph.pptx')
## insert into ppt 
my_ppt <- my_ppt %>% ph_with(dml(ggobj=p),
                             location = ph_location_label(ph_label = 'R Placeholder'))
## save/download ppt 
print(my_ppt, paste0('Presentation.pptx'))
