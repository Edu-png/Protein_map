# Visualização 3D de Proteínas

![CAPAS - PROJETOS](https://github.com/user-attachments/assets/b8403373-679c-4b2c-8e74-430dd3c2eae5)

[![GitHub](https://img.shields.io/badge/GitHub-Eduardo%20Coqueiro-blue?style=flat&logo=github)](https://github.com/Edu-png)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Eduardo%20Coqueiro-blue?style=flat&logo=linkedin)](https://www.linkedin.com/in/eduardocoqueiro)
[![Kaggle](https://img.shields.io/badge/Kaggle-Eduardo%20Coqueiro-blue?style=flat&logo=kaggle)](https://www.kaggle.com)
[![Email](https://img.shields.io/badge/Email-eduardocoqueiro%40gmail.com-blue?style=flat&logo=gmail)](mailto:eduardocoqueiro@gmail.com)

# Sumário

1. [Introdução](#introdução)
2. [Objetivo](#objetivo)
3. [Método](#método)
    1. [Leitura do Arquivo PDB](#leitura-do-arquivo-pdb)
    2. [Extração das Coordenadas XYZ](#extração-das-coordenadas-xyz)
    3. [Criação do DataFrame](#criação-do-dataframe)
    4. [Ajuste de Cores e Tamanhos dos Átomos](#ajuste-de-cores-e-tamanhos-dos-átomos)
    5. [Visualização 3D](#visualização-3d)
    6. [Interatividade](#interatividade)
4. [Resultados](#resultados)
    1. [Observações](#observações)
5. [Considerações Finais](#considerações-finais)
6. [Dependências](#dependências)
7. [Como Usar](#como-usar)
    1. [Instalar as dependências](#instalar-as-dependências)
    2. [Alterar o diretório](#alterar-o-diretório)
    3. [Rodar o código](#rodar-o-código)
8. [Agradecimentos](#agradecimentos)

## Introdução

Este projeto foi desenvolvido como parte do meu estágio no **Laboratório de Bioinformática e Data Science** na **UFBA**. O objetivo principal deste trabalho foi construir uma visualização 3D interativa de uma proteína a partir de um arquivo **PDB** (Protein Data Bank), que contém as coordenadas dos átomos em três dimensões. A visualização é útil para estudar a estrutura molecular das proteínas e pode ser aplicada em áreas como modelagem molecular, pesquisa de medicamentos e análise de interações moleculares.

O projeto foi realizado utilizando a linguagem de programação **R** e as bibliotecas **rgl** e **plotly** para criar gráficos 3D interativos. A visualização permite ao usuário explorar a estrutura da proteína e entender como os átomos estão organizados no espaço tridimensional.

## Objetivo

O objetivo deste projeto é gerar uma visualização 3D das proteínas, permitindo a análise das suas estruturas atômicas. A visualização utiliza as coordenadas dos átomos extraídas de arquivos PDB e apresenta os átomos em forma de esferas com cores e tamanhos ajustados conforme o tipo de átomo, facilitando a compreensão das diferentes propriedades químicas envolvidas.

## Método

### 1. **Leitura do Arquivo PDB**
A primeira etapa do processo é a leitura do arquivo **PDB**. Este arquivo contém informações sobre a posição de cada átomo na proteína, incluindo suas coordenadas X, Y, Z, e o tipo de átomo.

```r
arquivo_pdb = readLines("1mbd.pdb")
```

2. Extração das Coordenadas XYZ
As coordenadas XYZ dos átomos são extraídas das linhas do arquivo PDB que contêm informações sobre os átomos. O código busca as linhas que começam com a palavra-chave ATOM, que indicam as posições dos átomos na proteína.

```r
linhas_com_ATOM = grep(pattern = "ATOM", x = arquivo_pdb)
linhas_com_XYZ = arquivo_pdb[linhas_com_ATOM]
```

3. Criação do DataFrame
As coordenadas XYZ (X, Y, Z) e o tipo de átomo (representado pela letra) são extraídas e organizadas em um data.frame para facilitar o processamento e a visualização.

```r
POS_XYZ =  data.frame(X = numeric(),
                      Y = numeric(),
                      Z = numeric(),
                      A = character(),
                      stringsAsFactors = F)
```

4. Ajuste de Cores e Tamanhos dos Átomos
A cor e o tamanho das esferas são ajustados conforme o tipo de átomo. Os átomos de oxigênio (O) são coloridos de verde, carbono (C) em cinza, nitrogênio (N) em azul e enxofre (S) em amarelo. O tamanho das esferas é ajustado com base no raio atômico.

```r
cores = POS_XYZ$A
cores = gsub(pattern = "O", replacement = "green", x = cores)
cores = gsub(pattern = "C", replacement = "gray", x = cores)
cores = gsub(pattern = "N", replacement = "blue", x = cores)
cores = gsub(pattern = "S", replacement = "yellow", x = cores)
```

O tamanho dos átomos também é ajustado com base em seus raios atômicos, utilizando um fator de escala para torná-los visualmente proporcionais.

```r
tamanho = POS_XYZ$A
tamanho = gsub(pattern = "O", replacement = 10, x = tamanho)
tamanho = gsub(pattern = "C", replacement = 12, x = tamanho)
tamanho = gsub(pattern = "N", replacement = 27, x = tamanho)
tamanho = gsub(pattern = "S", replacement = 26, x = tamanho)
tamanho = as.numeric(tamanho)
```

5. Visualização 3D
A visualização é gerada utilizando as bibliotecas rgl e plotly, que permitem a criação de gráficos interativos em 3D. A visualização permite ao usuário rotacionar e explorar a estrutura da proteína.

```r
library(rgl)
with(POS_XYZ, plot3d(X, Y, Z, type = "s", col = cores, size = tamanho / 10))
```

6. Interatividade
A visualização é totalmente interativa, permitindo ao usuário explorar a estrutura da proteína em 3D, girando a visualização para ver os átomos de diferentes ângulos.

```r
movie3d(spin3d(axis=c(0,0,1), rpm = 15), duration = 15, dir = './')
```

## Resultados

![movie](https://github.com/user-attachments/assets/f0c950f2-804e-4021-90e5-444ca10cb87f)

A visualização gerada a partir deste processo mostra os átomos da proteína representados como esferas coloridas, com tamanhos ajustados conforme o tipo de átomo. Abaixo está a visualização do modelo da proteína 1mbd:


## Observações:
Cores: Cada tipo de átomo (oxigênio, carbono, nitrogênio, enxofre) tem uma cor distinta. O oxigênio é verde, o carbono é cinza, o nitrogênio é azul e o enxofre é amarelo.
Tamanhos: O tamanho das esferas é proporcional ao raio atômico de cada elemento. O carbono serve como referência, e os outros elementos são dimensionados de acordo.
Interatividade: A visualização permite rotacionar a proteína e explorar sua estrutura de diferentes ângulos.
Considerações Finais
Este projeto serve como uma implementação inicial para a visualização de estruturas de proteínas. Embora ainda não tenha passado por muitas validações, ele fornece uma base sólida para futuros aprimoramentos, como a inclusão de novas funcionalidades, a validação das coordenadas atômicas e a adição de outras propriedades moleculares.

## Dependências
rgl: Para visualização 3D interativa.
plotly: Para gráficos interativos em 3D.
tidyverse (opcional): Para manipulação de dados e leitura de arquivos.
readxl (opcional): Para leitura de planilhas Excel, caso necessário.
Como Usar
Instalar as dependências:
Caso ainda não tenha as bibliotecas necessárias, instale-as usando o seguinte código:

```r
install.packages("rgl")
install.packages("plotly")
install.packages("tidyverse")  # Opcional
install.packages("readxl")     # Opcional
```
Alterar o diretório:
Altere o diretório para o local onde o seu arquivo PDB está armazenado.


```r
setwd("/caminho/para/seu/arquivo")
arquivo_pdb = readLines("seu_arquivo.pdb")
```
Rodar o código:
Após carregar o arquivo, execute o script em R para gerar a visualização 3D da proteína. A visualização será aberta em uma janela interativa onde você pode rotacionar e explorar a estrutura.

## Considerações Finais

Este projeto oferece uma abordagem inicial para a visualização de estruturas proteicas em 3D, utilizando dados do PDB (Protein Data Bank) e as bibliotecas **rgl** e **plotly** em **R**. Embora a implementação ainda esteja em seus estágios iniciais, ela serve como uma base importante para o desenvolvimento de visualizações mais avançadas e análises adicionais no campo da Bioinformática.

A visualização gerada permite uma exploração interativa das estruturas das proteínas, ajudando a entender melhor a organização atômica e as interações moleculares que ocorrem dentro de uma proteína. As cores e tamanhos das esferas representam diferentes tipos de átomos e seus respectivos raios atômicos, o que facilita a identificação das propriedades químicas.

Embora o código tenha sido desenvolvido com o objetivo de gerar visualizações básicas, ele ainda precisa de validações adicionais para garantir 

## Agradecimentos

Gostaria de expressar minha sincera gratidão a todos que contribuíram para o desenvolvimento deste projeto. Agradeço imensamente ao **Laboratório de Bioinformática e Data Science da UFBA** pela oportunidade de realizar este estágio e pela orientação fornecida ao longo do processo.

Agradeço também ao meu orientador, **[Nome do Orientador]**, por seu apoio constante e por compartilhar seu vasto conhecimento na área de Bioinformática. Sua orientação foi fundamental para o sucesso deste trabalho.

Agradeço aos colegas de estágio e membros do laboratório pelas discussões construtivas, feedbacks e suporte durante o desenvolvimento do projeto. O ambiente colaborativo foi essencial para o aprendizado contínuo e para o crescimento profissional.

Além disso, sou grato às comunidades open source e aos desenvolvedores das bibliotecas utilizadas neste projeto, como **rgl**, **plotly** e **tidyverse**, que oferecem ferramentas poderosas que permitem a realização de trabalhos científicos e acadêmicos como este.
