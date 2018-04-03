# library(dplyr)
# library(ggplot2)
# library(grid)
# library(gridExtra)
# library(reshape2)
# library(scales)

png(paste(Sys.getenv('IMAGE_PATH'), "cfd.png", sep = ''), width=1300,height=600)

df.cfd <- read.csv(Sys.getenv('KANBAN_FILE_PATH'), header = TRUE, sep = ',')

gerarCFDTimesJuntos <- function(dateBreaks, dateMinorBreaks) {
  agruparPorData <- df.cfd %>%
    group_by(Data) %>%
    summarise('Backlog' = sum(Backlog), 
              'Desenvolvimento' = sum(Desenvolvimento), 
              'AWS Dev' = sum(AmbienteDev), 
              'AWS Hml' = sum(AmbienteHml),
              'Validacao PO' = sum(AguardandoPO),
              'Pronto Para PPD' = sum(AguardandoPpd),
              'Em Pré Produção' = sum(EntregueTotal))
  
  DF1 <- melt(agruparPorData, id.var = "Data")
  
  cdf_canais_geral <- ggplot(DF1, aes(x = as.Date(Data, format = "%d/%m/%Y"), y = value, fill = variable)) +
    geom_area() + 
    geom_vline(data = df.cfd, aes(xintercept = as.Date(Data, format = "%d/%m/%Y")), linetype = "longdash") +
    labs(x = "Semanas", y = "Contagem", fill = 'Status') +
    scale_x_date(date_breaks = dateBreaks, date_minor_breaks = dateMinorBreaks, date_labels = "%d/%m") +
    # theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
    scale_fill_brewer(palette="Spectral") +
    theme_bw()
}

#CONFIGURACAO GRID
grid.arrange(gerarCFDTimesJuntos(dateBreaks = "1 week", dateMinorBreaks = "1 day"), 
             ncol=1, 
             top=textGrob("Cumulative Flow Diagram", vjust = 1, gp=gpar(fontface="bold", fontsize=15)))

grid.rect(width = .99, height = .99, gp = gpar(lwd = 1, col = "black", fill = NA))

dev.off()