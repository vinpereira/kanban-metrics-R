# library(ggplot2)

png(paste(Sys.getenv('IMAGE_PATH'), "quality.png", sep = ''), width=1300,height=600)

df.quality <- read.csv(Sys.getenv('DEMANDS_FILE_PATH'), header = TRUE, sep = ',')

q1 <- ggplot(data = df.quality, aes(x = Sprint, group = 1)) +
  geom_point(aes(y = ValorAcumulado), color = "green") +
  geom_point(aes(y = FalhaAcumulada), color = "red") +
  geom_point(aes(y = MelhoriaAcumulada), color = "blue") +
  geom_line(aes(y = ValorAcumulado, color = "Valor")) + 
  geom_line(aes(y = FalhaAcumulada, color = "Falha")) +
  geom_line(aes(y = MelhoriaAcumulada, color = "Melhoria")) +
  scale_colour_manual(values = c("red", "blue", "green"), name = 'Tipo') +
  labs(x = "Sprint", y = "Acumulado", title = 'Qualidade da Demanada') +
  theme_bw()

print(q1)

dev.off()