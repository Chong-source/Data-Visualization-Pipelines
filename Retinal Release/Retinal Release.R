#--------- Load packages to for today's session ----------#
library(tidyverse)
library(ggbeeswarm)
#library(RColorBrewer)
#library(viridis)
library(ggthemes)
library(ggpubr)
library(UpSetR)
#scale_color_manual(name = "Variant",values = c( "WT" = "black", "L76P" = "green", "F313L" = "blue", "L76P/F313L" = "purple"),labels = c("WT", "L76P", "F313L", "L76P/F313L"))

#-----------------------------------------
Fig_A.df <- read_csv("RetRel_Chong.csv")

ggplot(data = Fig_A.df)+

geom_point(aes(WT_Time, WT_Int), colour="black", linewidth=0.5)+
geom_line(aes(WT_CF_Time,WT_CF_Int), colour="black", linewidth=1)+

geom_point(aes(F313L_Time, F313L_Int), colour="blue", linewidth=0.5)+
geom_line(aes(F313L_CF_Time,F313L_CF_Int), colour="blue", linewidth=1)+
  
geom_point(aes(L76P_Time, L76P_Int), colour="green", linewidth=0.5)+
geom_line(aes(L76P_CF_Time,L76P_CF_Int), colour="green", linewidth=1)+
  
geom_point(aes(Fx_Time, Fx_Int), colour="purple", linewidth=0.5)+
geom_line(aes(Fx_CF_Time,Fx_CF_Int), colour="purple", linewidth=1)+labs(

y= "Normalized Fluorescence:  (F-F0)/(Ffinal-F0)", x = "Time(min)") + theme_bw()+ expand_limits(y=c(0,0.04)) + theme(
axis.text.x = element_text(colour = 'black', size = 20, hjust = 0.5, vjust = 0.5), axis.title.x = 
element_text(size = 15, hjust = 0.5, vjust = 0.2))+ 
theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),axis.text.y = element_text(colour = 'black', size = 20), axis.title.y = 
element_text(size = 15, hjust = 0.5, vjust = 1.5)) + 
theme(strip.text.x = element_text(size = 20, hjust = 0.5, vjust = 0.5, face = 'bold'))




