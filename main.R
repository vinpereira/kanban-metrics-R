# Instala os pacotes necessários -- demora um pouco
list.of.packages <- c("dplyr","grid","gridExtra","reshape2","scales", "ggplot2")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages,function(x){library(x,character.only=TRUE)}) 

# Carrega os pacotes
library(dplyr)
library(ggplot2)
library(grid)
library(gridExtra)
library(reshape2)
library(scales)

# Trocar pelo nome do time
Sys.setenv(TEAM = 'MyTeam')

# Caminho onde estão os CSV -- HOME no Windows é a pasta Documentos
Sys.setenv(DEMANDS_FILE_PATH = paste(Sys.getenv('HOME'), "/kanban-metrics-R/metrics/", Sys.getenv('TEAM'), "_demandas.csv", sep = ''))
Sys.setenv(KANBAN_FILE_PATH = paste(Sys.getenv('HOME'), "/kanban-metrics-R/metrics/", Sys.getenv('TEAM'), "_kanban.csv", sep = ''))

# Caminho onde as imagens serão salvas
Sys.setenv(IMAGE_PATH = paste(Sys.getenv('HOME'), "/kanban-metrics-R/images/", Sys.getenv('TEAM'), "/", sep = ''))

# source("./scripts/lead_time.R")
# source("./scripts/histogram.R")
# source("./scripts/throughput.R")
# source("./scripts/quality.R")
# source("./scripts/cfd.R")

source("./scripts/lead_time_v2.R")
source("./scripts/histogram_v2.R")
source("./scripts/throughput_v2.R")
source("./scripts/quality_v2.R")
source("./scripts/cfd_v2.R")