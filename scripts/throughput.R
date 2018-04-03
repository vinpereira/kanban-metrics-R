# library(ggplot2)

png(paste(Sys.getenv('IMAGE_PATH'), "throughput.png", sep = ''), width=1300,height=600)

df.throughput <- read.csv(Sys.getenv('DEMANDS_FILE_PATH'), header = TRUE, sep = ',')

t1 <- ggplot(data = df.throughput, aes(x = Sprint)) + 
  geom_point(na.rm = TRUE, aes(y = Valor), size = 6, color = "green", shape = 16) +
  geom_point(na.rm = TRUE, aes(y = Falha), size = 3, color = "red", shape = 16) +
  geom_point(na.rm = TRUE, aes(y = Melhoria), size = 4, color = "blue", shape = 16) +
  xlim(min(df.throughput$Sprint), max(df.throughput$Sprint)) +
  labs(x = "Sprint", y = "Entregas") +
  theme_bw()

print(t1)

dev.off()