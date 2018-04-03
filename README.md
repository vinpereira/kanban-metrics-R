# Veloe - Indicadores utilizando R
### Instalar (Windows):
1. Git - https://git-scm.com/download/win

2. R-3.4.3 for Windows (32/64 bit) - https://cran.r-project.org/bin/windows/base/R-3.4.3-win.exe

3. RStudio 1.1.423 - Windows Vista/7/8/10 - https://download1.rstudio.org/RStudio-1.1.423.exe

4. Gerar ssh

### Requisitos
- Ter R instalado
-- Execute `R --version` para verificar se está instalado corretamente
- Ter o RStudio instalado
- Ter dois arquivos CSV (`NOMEDOTIME_demandas.csv` e `NOMEDOTIME_kanban.csv`) na pasta *metrics*
-- Estes arquivos **NÃO** devem ter as colunas modificadas

### Execução
1. Abrir o arquivo `Indicadores.Rproj` (ele abrirá o RStudio)
2. Abrir o arquivo `main.R` no RStudio
-- Trocar o nome do time `Sys.setenv(TEAM = 'RAC')`
-- Exemplos de opções são: Narcos, Pirates, RAC, Rogue, Targaryen, Sputnik e Stark
3. Selecionar todo o código e executar
4. Pegar as imagens na pasta _images/NOMETOTIME_

#### Opções
- No arquivo `lead_time_v2.R` existem algumas explicações para executar apenas ele (e não o `main.R` com os5 scripts)
-- A mesma lógica se aplica aos outros 4 arquivos (histogram, quality, throughput e cfd)
- O `teste.Rmd` é um teste utilizando R e Markdown para montar um dashboard
-- Necessário instalar os pacotes `flexdashboard` e `rmarkdown`, além dos que estão no `main.R`
--- Pode ser instalado via RStudio, aba _packages_