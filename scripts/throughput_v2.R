# library(ggplot2)
# library(dplyr)
# library(reshape2)

png(paste(Sys.getenv('IMAGE_PATH'), "throughput.png", sep = ''), width=1300,height=600)

df.demands <- read.csv(Sys.getenv('DEMANDS_FILE_PATH'), header = TRUE, sep = ',')

sprints <- unique(df.demands$Sprint)

df.throughput <- data.frame(df.demands$Sprint, df.demands$Tipo)
colnames(df.throughput) <- c("Sprint", "Tipo")

df.throughput.casted <- dcast(df.throughput, Sprint ~ Tipo)
df.throughput.casted[df.throughput.casted == 0] <- NA

t <- ggplot(data = df.throughput.casted, aes(x = sprints)) + 
  geom_point(na.rm = TRUE, aes(y = Valor), size = 7, color = "green", shape = 16) +
  geom_point(na.rm = TRUE, aes(y = Melhoria), size = 5, color = "blue", shape = 16) +
  geom_point(na.rm = TRUE, aes(y = Falha), size = 3, color = "red", shape = 16) +
  # xlim(min(unique(df.throughput$Sprint)), max(unique(df.throughput$Sprint))) +
  labs(x = "Sprint", y = "Entregas") +
  theme_bw()

print(t)

dev.off()