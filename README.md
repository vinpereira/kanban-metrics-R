# Veloe - Indicadores utilizando R
### Instalar (Windows):
1. Git - https://git-scm.com/download/win

2. R-3.4.3 for Windows (32/64 bit) - https://cran.r-project.org/bin/windows/base/R-3.4.3-win.exe

3. RStudio 1.1.423 - Windows Vista/7/8/10 - https://download1.rstudio.org/RStudio-1.1.423.exe

4. Gerar ssh

### Requisitos
- Ter feito o _git clone_ deste repositório
- Ter R instalado
-- Execute `R --version` para verificar se está instalado corretamente
- Ter o RStudio instalado
- Ter um arquivo XLSX (`metricas_NOMEDOTIME.xlsx`) na pasta *metrics* deste repositório
- Ter um arquivo CSV (`NOMEDOTIME_demandas.csv`) na pasta *metrics* deste repositório
-- Este arquivo é utilizado para gerar todos os gráficos, com exceção do CFD
- Ter um arquivo CSV (`NOMEDOTIME_kanban.csv`) na pasta *metrics* deste repositório
-- Este arquivo é utilizado para gerar o CFD
- Executar o arquivo `instal-packages.R` via RStudio na primeira vez, para garantir a instalação de todos os pacotes necessários

### Execução
1. Abrir o arquivo `Veloe-Indicadores.Rproj` no RStudio
2. Abrir o arquivo `dashboard.Rmd`
2.1. Trocar o nome do time em `Sys.setenv(TEAM = 'MyTeam')`
2.2. Trocar o nome do time em `title: "MyTeam Dashboard"`
3. Executar o código (botão `Knit`)
4. O Dashboard será gerado em uma nova janela, além de um arquivo HTML