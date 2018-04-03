# library(ggplot2)
# library(dplyr)
# library(reshape2)

png(paste(Sys.getenv('IMAGE_PATH'), "quality.png", sep = ''), width=1300,height=600)

df.demands <- read.csv(Sys.getenv('DEMANDS_FILE_PATH'), header = TRUE, sep = ',')

sprints <- unique(df.demands$Sprint)

df.quality <- data.frame(df.demands$Sprint, df.demands$Tipo)
colnames(df.quality) <- c("Sprint", "Tipo")

df.quality.casted <- dcast(df.quality, Sprint ~ Tipo)

Valor.accumulated <- c()
for (i in 1:length(df.quality.casted$Valor)) {
  if (i == 1) {
    Valor.accumulated[i] <- df.quality.casted$Valor[i]  
  }
  else {
    Valor.accumulated[i] <- df.quality.casted$Valor[i] + Valor.accumulated[i - 1]
  }
}
Valor.accumulated[Valor.accumulated == 0] <- NA

Melhoria.accumulated <- c()
for (i in 1:length(df.quality.casted$Melhoria)) {
  if (i == 1) {
    Melhoria.accumulated[i] <- df.quality.casted$Melhoria[i]  
  }
  else {
    Melhoria.accumulated[i] <- df.quality.casted$Melhoria[i] + Melhoria.accumulated[i - 1]
  }
}
Melhoria.accumulated[Melhoria.accumulated == 0] <- NA

Falha.accumulated <- c()
for (i in 1:length(df.quality.casted$Falha)) {
  if (i == 1) {
    Falha.accumulated[i] <- df.quality.casted$Falha[i]  
  }
  else {
    Falha.accumulated[i] <- df.quality.casted$Falha[i] + Falha.accumulated[i - 1]
  }
}
Falha.accumulated[Falha.accumulated == 0] <- NA

q <- ggplot(data = df.quality.casted, aes(x = Sprint, group = 1)) +
  geom_point(na.rm = TRUE, aes(y = Valor.accumulated), color = "green") +
  geom_point(na.rm = TRUE, aes(y = Falha.accumulated), color = "red") +
  geom_point(na.rm = TRUE, aes(y = Melhoria.accumulated), color = "blue") +
  geom_line(na.rm = TRUE, aes(y = Valor.accumulated, color = "Valor")) + 
  geom_line(na.rm = TRUE, aes(y = Falha.accumulated, color = "Falha")) +
  geom_line(na.rm = TRUE, aes(y = Melhoria.accumulated, color = "Melhoria")) +
  scale_colour_manual(values = c("red", "blue", "green"), name = 'Tipo') +
  labs(x = "Sprint", y = "Acumulado", title = 'Qualidade da Demanada') +
  theme_bw()

print(q)

dev.off()
