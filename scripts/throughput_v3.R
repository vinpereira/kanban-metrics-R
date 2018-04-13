library(ggplot2)
library(dplyr)
library(reshape2)

df.demands <- read.csv('/home/vinicius/workspace/kanban-metrics-R/metrics/RAC_demandas.csv', header = TRUE, sep = ',')

## ---- throughput
df.throughput <- data.frame(df.demands$Sprint, df.demands$Tipo)
colnames(df.throughput) <- c("Sprint", "Tipo")

df.throughput.casted <- dcast(df.throughput, Sprint ~ Tipo)
df.throughput.casted[df.throughput.casted == 0] <- NA

ggplot(data = df.throughput.casted, aes(x = Sprint)) + 
  geom_point(na.rm = TRUE, aes(y = Valor), size = 7, color = "green", shape = 16) +
  geom_point(na.rm = TRUE, aes(y = Melhoria), size = 5, color = "blue", shape = 16) +
  geom_point(na.rm = TRUE, aes(y = Falha), size = 3, color = "red", shape = 16) +
  labs(x = "Sprint", y = "Entregas") +
  theme_bw()
## ---- end-of-throughput