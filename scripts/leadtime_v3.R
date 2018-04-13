library(ggplot2)
library(reshape2)
library(zoo)

df.demands <- read.csv('/home/vinicius/workspace/kanban-metrics-R/metrics/RAC_demandas.csv', header = TRUE, sep = ',')

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
df.days <- data.frame(df.demands$Indice, dev.time, aws.dev.time, aws.hml.time, po.time, ppd.ready.time)
colnames(df.days) <- c("Indice", "Desenvolvimento", "AWS Dev", "AWS Hml", "Em Validação", "Pronto p/ Ppd")

# Denormaliza os dados do dataframe
df.days.melted <- melt(df.days, id.vars = "Indice")
colnames(df.days.melted) <- c("Indice","Etapas", "Valores")

# Número de PBI por Sprint
pbi.by.sprint <- length(df.demands$Sprint) - match(unique(df.demands$Sprint), rev(df.demands$Sprint)) + 1

# teste <- movavg(lead.time, length(lead.time) - 4, "s")

## ---- leadtime
ggplot(data = df.demands, aes(x = Indice, y = lead.time)) +
  geom_point(aes(shape = Classe, color = Classe, size = Classe)) +
  geom_text(aes(x = Indice, y = lead.time, label = PBI, vjust = -0.8, angle = 0), size = 2) +geom_vline(xintercept = pbi.by.sprint + 0.5, color = "grey", linetype = "longdash") +
  scale_size_manual(values = c(3, 3)) +
  geom_line(aes(color = Classe)) +
  annotate("text", x = pbi.by.sprint + 0.5, y = mean(lead.time) + 15, label = paste("Sprint", unique(df.demands$Sprint)), size=4, angle = 90, vjust = -0.5, color = "grey") +
  scale_x_continuous(breaks = df.demands$Indice) +
  # geom_line(aes(y = teste, colour = 'grey')) +
  geom_line(na.rm = TRUE, aes(y = rollmean(x = lead.time, k = length(lead.time) - 4, fill = NA, align = 'right'))) +
  scale_fill_brewer(palette = "Spectral") +
  labs(x = "Indice", y = 'Dias Corridos') +
  theme_bw() + 
  theme(legend.position = "top", legend.title = element_blank()) +
  guides(fill = guide_legend(nrow = 1, byrow = TRUE))
## ---- end-of-leadtime
