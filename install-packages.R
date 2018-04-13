# Instala os pacotes necessários -- demora um pouco
list.of.packages <- c("dplyr","grid","gridExtra","reshape2","scales", "ggplot2", "zoo", "knitr", "pracma")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages,function(x){library(x,character.only=TRUE)}) 