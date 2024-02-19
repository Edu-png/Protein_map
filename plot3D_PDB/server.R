#Autor: Leandro Martins de Freitas
#versao: 1
#data: 10/Nov/2022

library(rgl)
library(car)
#library(ggplot2)
#library(rayshader)
library(shiny)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  #tarefas colocar opção de plot com totos os atomos ou CA
  #colocar opçao de tamanho da esfera
  #colocar opção de tamanho da linha do plot no CA

   # output$distPlot1 <- renderPlot({
  #    
  #    X = rnorm(n = 100, mean = 0, sd = 1)
  #    Y = rnorm(n = 100, mean = 2, sd = 1.5)
  #    Z = rnorm(n = 100, mean = 5, sd = 1.5)

      
      #df <- data.frame(X=X,
      #                 Y=Y, 
      #                 Z=Z)
    #})  
    
    
    output$plot <- renderRglwidget({
      
      
      
      arquivo_pdb = readLines("1mbd.pdb")
      #print(arquivo_pdb[1:2])
      ##selecionando as linhas com informacoes com com posicao XYZ dos atomos na proteínas
      linhas_com_ATOM = grep(pattern = "ATOM", x = arquivo_pdb)
      ##selecionando as informacoes com com posicao XYZ dos atomos na proteínas
      linhas_com_XYZ = arquivo_pdb[linhas_com_ATOM]
      ##verificar as 10 primeiras linhas
      #print(linhas_com_XYZ[1:10])
      
      ##Criando o data frame que separa o arquivo em elementos de um vetor para recuperar as posicoes 7,8, e 9 com as infos XYZ
      
      POS_XYZ =  data.frame(X = numeric(),
                            Y =  numeric(),
                            Z = numeric(),
                            A = character(),
                            stringsAsFactors = F)
      #Criando o loop:
      
      #POS_XYZ
      for(conta_linhas in 1:length(linhas_com_XYZ)){
        POS_XYZ[conta_linhas,] = unlist(strsplit(x = linhas_com_XYZ[conta_linhas], split = "\\s+"))[c(7:9,12)]
      }
      #print(dim(POS_XYZ))
      ##POS_XYZ[1:20,]
      
      POS_XYZ = POS_XYZ[c(9:length(POS_XYZ$X)),]
      #POS_XYZ[1:10]
      # Instalando os pacotes necessários:
      #print(POS_XYZ[1:4,])
      #install.packages("plot3D")
      #install.packages("rgl")
      #install.packages("tidyverse")
      #install.packages("readxl")
      #install.packages("plotly")
      
      # Chamando os pacotes:
      
      #library(rgl)
      #library(plotly)
      #library(tidyverse)
      #library(readxl)
      
      #library(plot3D)
      
      #Mudando as cores de cada um dos átomos conforme o seu tipo:
      
      #cores = POS_XYZ$A
      
      #cores = gsub(pattern = "O", replacement = "green", x = cores)
      #cores = gsub(pattern = "C", replacement = "gray", x = cores)
      #cores = gsub(pattern = "N", replacement = "blue", x = cores)
      #cores = gsub(pattern = "S", replacement = "yellow", x = cores)
      #print(cores[1:10]
      #with(POS_XYZ, plot3d(POS_XYZ$X,POS_XYZ$Y,POS_XYZ$Z, col = cores, type = "s",size = 1.5))
      
      tamanho = POS_XYZ$A
      
      tamanho = gsub(pattern = "O", replacement = 2, x = tamanho) #raio de 60 pm
      tamanho = gsub(pattern = "C", replacement = 2.5, x = tamanho) #raio de 70 pm
      tamanho = gsub(pattern = "N", replacement = 2.25, x = tamanho) #raio de 65 pm
      tamanho = gsub(pattern = "S", replacement = 4, x = tamanho)#raio de 100 pm
      
      tamanho = as.numeric(tamanho) #Converter para numérico para que possa ser reconhecido pelo comando size.
      
      color_range = colorRampPalette(c("#480172", "red"))
      #color_range = colorRampPalette(c("red", "green"))
      
      my_colors = color_range(1000)
      
      with(POS_XYZ, plot3d(X,Y,Z, type = "s", size = tamanho, col = my_colors[rank(X)]))
      
      
      rgl.open(useNULL=T)
      bg3d(color = "white")
  
      
      #scatter3d(as.numeric(iris$Sepal.Length),as.numeric(iris$Sepal.Width), as.numeric(iris$Petal.Length) ,surface=F, ellipsoid = F, 
      #           sphere.size=3)

      with(POS_XYZ, plot3d(X,Y,Z, type = "s", size = tamanho, col = my_colors[rank(X)]),bboxdeco)
      
      
      #scatter3d(as.numeric(POS_XYZ$X),as.numeric(POS_XYZ$Y), as.numeric(POS_XYZ$Z), col = cores ,surface=F, ellipsoid = F, 
                #point.col=cores, sphere.size=3)
      
      
      #with(POS_XYZ, plot3d(POS_XYZ$X,POS_XYZ$Y,POS_XYZ$Z, col = cores, type = "s",size = 1.5, xlim= c(-20,50), ylim = c(-20,50), zlim=c(-20,50)))
      
     
      rglwidget()
    })
})
