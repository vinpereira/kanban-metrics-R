# SE EXECUTAR APENAS ESTE ARQUIVO, ENTÃO DESCOMENTE AS LINHAS 2 e 3
# library(ggplot2)
# library(reshape2)

# SE FOR EXECUTAR APENAS ESSE ARQUIVO, TEM QUE CONFIGURAR O CAMINHO PARA O CSV (descomente a linha abaixo)
# Sys.setenv(DEMANDS_FILE_PATH = paste(Sys.getenv('HOME'), "/indicadores/metrics/", Sys.getenv('TEAM'), "_demandas.csv", sep = ''))

# SE EXECUTAR APENAS ESTE ARQUIVO, ENTÃO COMENTE AS LINHAS 9 e 67 --> Assim o gráfico aparecerá aqui no RStudio
png(paste(Sys.getenv('IMAGE_PATH'), "lead_time.png", sep = ''), width=1300,height=600)

# Carrega a planilha
df.demands <- read.csv(Sys.getenv('DEMANDS_FILE_PATH'), header = TRUE, sep = ',')

# Calcula o tempo (dias corridos) em cada coluna do Kanban
dev.time <- as.numeric((as.Date(as.character(df.demands$Dev), format="%d/%m/%Y") - as.Date(as.character(df.demands$Inicio), format="%d/%m/%Y")), units = 'days')
aws.dev.time <- as.numeric((as.Date(as.character(df.demands$Hml), format="%d/%m/%Y") - as.Date(as.character(df.demands$Dev), format="%d/%m/%Y")), units = 'days')
aws.hml.time <- as.numeric((as.Date(as.character(df.demands$PO), format="%d/%m/%Y") - as.Date(as.character(df.demands$Hml), format="%d/%m/%Y")), units = 'days')
po.time <- as.numeric((as.Date(as.character(df.demands$ProntoPpd), format="%d/%m/%Y") - as.Date(as.character(df.demands$PO), format="%d/%m/%Y")), units = 'days')
ppd.ready.time <- as.numeric((as.Date(as.character(df.demands$Ppd), format="%d/%m/%Y") - as.Date(as.character(df.demands$ProntoPpd), format="%d/%m/%Y")), units = 'days')

# Calcula Touch Time, Queue Time e Lead Time
touch.time <- as.numeric(dev.time + aws.dev.time + aws.hml.time, units = 'days')
queue.time <- as.numeric(po.time + ppd.ready.time, units = 'days')
lead.time <- as.numeric(touch.time + queue.time, units = 'days')

# Monta um dataframe com os dias corridos calculados
df.days <- data.frame(df.demands$Indice, 0, dev.time, aws.dev.time, aws.hml.time, po.time, ppd.ready.time, 0)
colnames(df.days) <- c("Indice", "Backlog", "Desenvolvimento", "AWS Dev", "AWS Hml", "Em Validação", "Pronto p/ Ppd", "Em Pré Prod")

# Denormaliza os dados do dataframe
df.days.melted <- melt(df.days, id.vars = "Indice")
colnames(df.days.melted) <- c("Indice","Etapas", "Valores")

# Número de PBI por Sprint
pbi.by.sprint <- length(df.demands$Sprint) - match(unique(df.demands$Sprint), rev(df.demands$Sprint)) + 1

# Função para calcular confiança com 90%
calc_conf90 <- function(value) {
  conf.90 <- t.test(x = value, conf.level = 0.9)
  return (conf.90$conf.int[2])
}

conf.leadtime <- calc_conf90(lead.time)

# Gera o gráfico com os pontos (scatterplot) e as barras (barplot)
p <- ggplot(data = df.demands, aes(x = Indice, y = lead.time)) +
  geom_bar(stat = "identity", data = df.days.melted, aes(fill = Etapas, y = Valores), alpha = 1) +
  geom_point(aes(shape = Classe, color = Classe, size = Classe)) +
  geom_text(aes(x = Indice, y = lead.time, label = PBI, vjust = -0.8, angle = 0), size = 3) +
  # geom_text(aes(x = Indice, y = lead.time, label = touch.time, vjust = 1.8, angle = 0), size = 4) +
  # geom_text(aes(x = Indice, y = queue.time, label = queue.time, vjust = 0.8, angle = 0), size = 4) +
  scale_shape_manual(values = c(17, 16)) +
  # scale_color_manual(values = c('red', 'green')) +
  scale_size_manual(values = c(3, 3)) +
  geom_vline(xintercept = pbi.by.sprint + 0.5, color = "grey", linetype = "longdash") +
  annotate("text", x = pbi.by.sprint + 0.5, y = mean(lead.time) + 15, label = paste("Sprint", unique(df.demands$Sprint)), size=4, angle = 90, vjust = -0.5, color = "grey") +
  scale_x_continuous(breaks = df.demands$Indice) +
  # scale_y_continuous(breaks = c(lead.time, touch.time, queue.time)) +
  geom_hline(yintercept = conf.leadtime, color = "red") +
  geom_text(aes(x = 0, y = conf.leadtime, label = paste("90% de Confiança - ", round(conf.leadtime, 2)), vjust = 2, hjust = 0)) +
  scale_fill_brewer(palette = "Spectral") +
  labs(x = "Indice", y = 'Dias Corridos', title = "Tempo de Entrega") +
  theme_bw()

print(p)

dev.off()
