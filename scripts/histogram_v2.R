# library(ggplot2)

png(paste(Sys.getenv('IMAGE_PATH'), "histogram.png", sep = ''), width=1300,height=600)

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

df.leadtime <- data.frame(df.demands$Indice, df.demands$Classe, lead.time)
colnames(df.leadtime) <- c("Indice", "Classe", "LeadTime")

h <- ggplot(data = df.leadtime, aes(x = LeadTime)) +
  geom_bar(aes(fill = Classe)) + 
  stat_function(fun = dnorm, color = "black", args = list(mean = mean(lead.time), sd = sd(lead.time))) +
  # geom_density() +
  labs(x = "Tempo de Entrega", y = "Frequência") +
  # scale_fill_manual(values=c('red', 'green')) +
  theme_bw()

print(h)

dev.off()
