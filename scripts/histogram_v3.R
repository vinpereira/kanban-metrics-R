library(ggplot2)

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

## ---- histogram
df.leadtime <- data.frame(df.demands$Indice, df.demands$Classe, lead.time)
colnames(df.leadtime) <- c("Indice", "Classe", "LeadTime")

aux.table <- table(lead.time)
lead.time.mod <- aux.table[aux.table == max(aux.table)]

lead.time.mean <- mean(lead.time)
lead.time.median <- median(lead.time)

percentiles <- quantile(lead.time, c(.75, .90))

ggplot(data = df.leadtime, aes(x = LeadTime)) +
  geom_bar(aes(fill = Classe)) + 
  stat_function(fun = dnorm, color = "black", args = list(mean = mean(lead.time), sd = sd(lead.time))) +
  geom_vline(xintercept = lead.time.mean, color = "black", linetype = "longdash") +
  annotate("text", x = lead.time.mean, y = 1, label = paste("Média =", round(lead.time.mean, digits = 2)), size=4, angle = 90, vjust = -0.5, color = "black") +
  geom_vline(xintercept = lead.time.median, color = "black", linetype = "longdash") +
  annotate("text", x = lead.time.median, y = 1, label = paste("Mediana =", round(lead.time.median, digits = 2)), size=4, angle = 90, vjust = -0.5, color = "black") +
  geom_vline(xintercept = as.vector(percentiles)[1], color = "black", linetype = "longdash") +
  annotate("text", x = as.vector(percentiles)[1], y = 1, label = paste("75% Conf -", round(as.vector(percentiles)[1], digits = 2)), size=4, angle = 90, vjust = -0.5, color = "black") +
  geom_vline(xintercept = as.vector(percentiles)[2], color = "black", linetype = "longdash") +
  annotate("text", x = as.vector(percentiles)[2], y = 1, label = paste("90% Conf -", round(as.vector(percentiles)[2], digits = 2)), size=4, angle = 90, vjust = -0.5, color = "black") +
  # geom_density() +
  labs(x = "Tempo de Entrega", y = "Frequência") +
  # scale_fill_manual(values=c('red', 'green')) +
  theme_bw() +
  theme(legend.position="top", legend.title = element_blank())
## ---- end-of-histogram