# library(ggplot2)
# library(grid)
# library(gridExtra)

png(paste(Sys.getenv('IMAGE_PATH'), "lead_time.png", sep = ''), width=1300,height=600)

# Carrega arquivo XLSX com os indicadores de um time
df.pbi <- read.csv(Sys.getenv('DEMANDS_FILE_PATH'), header = TRUE, sep = ',')

# Função para colocar 3 plots na mesma figura
grid_arrange_shared_legend <- function(..., ncol = length(list(...)), nrow = 1, position = c("bottom", "right")) {
  plots <- list(...)
  
  position <- match.arg(position)
  
  g <- ggplotGrob(plots[[1]] + theme(legend.position = position))$grobs
  
  legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
  
  lheight <- sum(legend$height)
  
  lwidth <- sum(legend$width)
  
  gl <- lapply(plots, function(x) x + theme(legend.position = "none"))
  
  gl <- c(gl, ncol = ncol, nrow = nrow)
  
  combined <- switch(
    position,
    "bottom" = arrangeGrob(
      do.call(arrangeGrob, gl),
      legend,
      ncol = 1,
      heights = unit.c(unit(1, "npc") - lheight, lheight)
    ),
    "right" = arrangeGrob(
      do.call(arrangeGrob, gl),
      legend,
      ncol = 2,
      widths = unit.c(unit(1, "npc") - lwidth, lwidth)
    )
  )
  
  grid.newpage()
  grid.draw(combined)
  
  # return gtable invisibly
  invisible(combined)
  
}

# Função para calcular confiança com 90%
calc_conf90 <- function(value) {
  conf.90 <- t.test(x = value, conf.level = 0.9)
  return (conf.90$conf.int[2])
}

pbi.by.sprint <- length(df.pbi$Sprint) - match(unique(df.pbi$Sprint), rev(df.pbi$Sprint)) + 1

# Função para gerar o plot do LeadTime e TouchTime (apenas pontos)
generate_plot <- function(timeValue, confValue, titleValue) {
  p <- ggplot(data = df.pbi, aes(x = Indice, y = timeValue, group = Classe)) +
    # geom_line(aes(linetype = Classe), size = 1, color = 'grey') +
    geom_point(aes(shape = Classe, color = Classe, size = Classe)) +
    geom_text(aes(x = Indice, y = timeValue, label = PBI, vjust = -0.8, angle = 0), size = 4) +
    scale_shape_manual(values = c(4, 16)) +
    scale_color_manual(values = c('red', 'green')) +
    scale_size_manual(values = c(3, 3)) +
    geom_hline(yintercept = confValue, color = "red") +
    geom_text(aes(x = 0, y = confValue, label = paste("90% de Confianca - ", round(confValue, 2)), vjust = 2, hjust = 0)) +
    labs(x = "Indice", y = 'Dias Uteis', title = titleValue) +
    theme_bw() + theme(legend.position="none") +
    # ylim(0, max(timeValue) + 1) +
    # xlim(0, max(df.pbi$Indice) + 1) +
    scale_x_continuous(breaks = df.pbi$Indice) +
    scale_y_continuous(breaks = timeValue) + 
    geom_vline(xintercept = pbi.by.sprint + 0.5, color = "grey", linetype = "longdash") +
    annotate("text", x = pbi.by.sprint + 0.5, y = mean(timeValue) + 1, label = paste("Sprint", unique(df.pbi$Sprint)), size=4, angle = 90, vjust = -0.5, color = "grey")
}

# Cálculo do QueueTime
queue.time <- df.pbi$POTime + df.pbi$PpdTime

# Número de PBI por Sprint
pbi.by.sprint <- length(df.pbi$Sprint) - match(unique(df.pbi$Sprint),rev(df.pbi$Sprint)) + 1

# Data Frame auxiliar para gerar as barras no gráfico
df.pbi.melted <- melt(df.pbi, id.vars = c("Indice", "Tipo", "Classe", "Sprint", "Feature", "PBI", "Nome", "Qtd.CT", "Inicio", "Dev", "Hml", "PO", "ProntoPpd", "Ppd", "Fim", "LeadTime", "TouchTime"))

# Função para gerar o plot do QueueTime com pontos e barras
generate_plot_queue <- function(confValue) {
  p <- ggplot(data = df.pbi, aes(x = Indice, y = queue.time, group = Classe)) +
    geom_bar(stat = "identity", data = df.pbi.melted, aes(fill = variable, y = value), alpha = 0.2) +
    scale_fill_manual(values = c("dimgray", "darkorange")) +
    geom_point(aes(shape = Classe, color = Classe, size = Classe)) +
    geom_text(aes(x = Indice, y = queue.time, label = PBI, vjust = -0.8, angle = 0), size = 4) +
    scale_shape_manual(values = c(4, 16)) +
    scale_color_manual(values = c('red', 'green')) +
    scale_size_manual(values = c(3, 3)) +
    geom_hline(yintercept = confValue, color = "red") +
    geom_text(aes(x = 0, y = confValue, label = paste("90% de Confianca - ", round(confValue, 2)), vjust = 2, hjust = 0)) +
    labs(x = "Indice", y = 'Dias Uteis', title = "Tempo na Fila") +
    theme_bw() + theme(legend.position = "none") +
    scale_x_continuous(breaks = df.pbi$Indice) +
    scale_y_continuous(breaks = queue.time) +
    geom_vline(xintercept = pbi.by.sprint + 0.5, color = "grey", linetype = "longdash") +
    annotate("text", x = pbi.by.sprint + 0.5, y = mean(queue.time) + 2, label = paste("Sprint", unique(df.pbi$Sprint)), size=4, angle = 90, vjust = -0.5, color = "grey")
}

## Lead Time ##
conf.leadtime <- calc_conf90(df.pbi$LeadTime)
p.leadtime <- generate_plot(timeValue = df.pbi$LeadTime, confValue = conf.leadtime, titleValue = 'Tempo de Entrega')

## Touch Time ##
conf.touchtime <- calc_conf90(df.pbi$TouchTime)
p.touchtime <- generate_plot(timeValue = df.pbi$TouchTime, confValue = conf.touchtime, titleValue = 'Tempo em Desenvolvimento')

## Queue Time ##
conf.queuetime <- calc_conf90(queue.time)
p.queuetime <- generate_plot_queue(confValue = conf.queuetime)

# Monta a figura
grid_arrange_shared_legend(p.leadtime, p.touchtime, p.queuetime)

dev.off()