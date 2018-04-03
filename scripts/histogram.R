# library(ggplot2)

png(paste(Sys.getenv('IMAGE_PATH'), "histogram.png", sep = ''), width=1300,height=600)

df.histogram <- read.csv(Sys.getenv('DEMANDS_FILE_PATH'), header = TRUE, sep = ',')

h1 <- ggplot(data = df.histogram, aes(x = LeadTime, fill = Classe)) +
  geom_bar() + 
  # stat_function(fun = dnorm, color = "black", args = list(mean = mean(df.histogram$LeadTime), sd = sd(df.histogram$LeadTime))) +
  # geom_line(density(df.histogram$LeadTime)) +
  geom_density() +
  labs(x = "Lead Time", y = "Count", title = 'Histograma') +
  theme_bw()

print(h1)

dev.off()