#Primeiro preciso saber em qual diretório estou trabalhando no meu pc
getwd()
#[1] "C:/Users/Eduardo/Desktop/estagio/estagio"
#Agora vou mudar o diretório para o do pen drive
setwd("/Users/leandrofreitas/Downloads/")
#setwd("F:\\DIRETÓRIO")
#agora basta seguir os passos até então para a enzima que escolhi:
arquivo_pdb = readLines("1mbd.pdb")

arquivo_pdb[1:20]

#selecionando as linhas com informacoes com com posicao XYZ dos atomos na proteínas
linhas_com_ATOM = grep(pattern = "ATOM", x = arquivo_pdb)
#selecionando as informacoes com com posicao XYZ dos atomos na proteínas
linhas_com_XYZ = arquivo_pdb[linhas_com_ATOM]
#verificar as 10 primeiras linhas
linhas_com_XYZ[1:10]

#Criando o data frame que separa o arquivo em elementos de um vetor para recuperar as posicoes 7,8, e 9 com as infos XYZ

POS_XYZ =  data.frame(X = numeric(),
                      Y =  numeric(),
                      Z = numeric(),
                      A = character(),
                      CA = character(),
                      stringsAsFactors = F)
#Criando o loop:

POS_XYZ
for(conta_linhas in 1:length(linhas_com_XYZ)){
  POS_XYZ[conta_linhas,] = unlist(strsplit(x = linhas_com_XYZ[conta_linhas], split = "\\s+"))[c(7:9,c(12,3))]
}
dim(POS_XYZ)
POS_XYZ[1:20,]

POS_XYZ = POS_XYZ[c(9:length(POS_XYZ$X)),]
POS_XYZ_CA = POS_XYZ[POS_XYZ$CA == "CA",]

#removendo NAs
posicoes_para_remover = !(is.na(POS_XYZ$A))
POS_XYZ_sem_NA = POS_XYZ[posicoes_para_remover,]
POS_XYZ_sem_NA
# Instalando os pacotes necessários:

#install.packages("plot3D")
#install.packages("rgl")
#install.packages("tidyverse")
#install.packages("readxl")
#install.packages("plotly")

# Chamando os pacotes:

library(rgl)
library(plotly)
#library(tidyverse)
#library(readxl)

#library(plot3D)
#definindo a forma de cada esfera
#forma = 

#Mudando as cores de cada um dos átomos conforme o seu tipo:
cores = POS_XYZ$A

cores = gsub(pattern = "O", replacement = "green", x = cores)
cores = gsub(pattern = "C", replacement = "gray", x = cores)
cores = gsub(pattern = "N", replacement = "blue", x = cores)
cores = gsub(pattern = "S", replacement = "yellow", x = cores)

dim(POS_XYZ)
dim(POS_XYZ_CA)
with(POS_XYZ, plot3d(POS_XYZ$X,POS_XYZ$Y,POS_XYZ$Z, col = cores, type = "s",size = 1.5))

with(POS_XYZ_CA, plot3d(POS_XYZ_CA$X,POS_XYZ_CA$Y,POS_XYZ_CA$Z, col = "black", type ="s",size = 1))

with(POS_XYZ_CA, plot3d(POS_XYZ_CA$X,POS_XYZ_CA$Y,POS_XYZ_CA$Z, col = "black", type ="l", lwd = 4))

Xlimit = c(mißn(POS_XYZ$X),max(POS_XYZ$X))
Ylimit = c(min(POS_XYZ$Y),max(POS_XYZ$Y))
Zlimit = c(min(POS_XYZ$Z),max(POS_XYZ$Z))

xcells = seq(Xlimit[1],dist(Xlimit), by = 1)
ycells = seq(Ylimit[1],dist(Ylimit), by = 1)
zcells = seq(Zlimit[1],dist(Zlimit), by = 1)
length(xcells)
length(ycells)
length(zcells)

volume = length(xcells) * length(ycells)* length(zcells)
result <- array(rep(x = 1,volume), dim = c(length(xcells), length(ycells),  length(zcells)))
dim(result)
ceiling(2.1)
result[1:3,1:3,1:3]
data1 <- c(1,2,3,4,5,6)
data2 <- c(60, 18, 12, 13, 14, 19)

# pass these vectors as input to the array.
#  4 rows,2 columns and 3 arrays
result <- array(c(data1, data2), dim = c(4,2,3))
print(result)


vertices <- c( 
  -1.0, -1.0, 0,
  1.0, -1.0, 0,
  1.0,  1.0, 0,
  -1.0,  1.0, 0
)
indices <- c( 1, 2, 3, 4 )

open3d()  
wire3d( mesh3d(vertices = vertices, quads = indices) )

#dim(POS_XYZ)
#dim(POS_XYZ_CA)
#Plotando em 3D e fazendo com que ele gire:

movie3d(spin3d(axis=c(0,0,1), rpm = 15), duration = 15, dir = './')

#Agora tenho que fazer com que seja feita a relação de tamanho. Abaixo temos algumas informações interessantes para o mesmo:

#A gente tem problemas nesse modelo, o primeiro é que todas as bolas tem o mesmo tamanho e o segundo é que todas tem a mesma coloração.
#Posso mudar o tamanho usando a função size, aqui vou usar o seguinte cálculo:

# Ordem de tamanho dos átomos 
# H = Ele já não considera o H como ponto. Tamanho de de 53 pm(raio atômico)
# C = tamanho de 70 pm(raio atômico)
# N = tamanho de 155 pm(raio atômico)
# O = tamanho de 60 pm(raio atômico)
# S = tamanho de 180 pm(raio atômico) 

#Vamos atribuir ao carbono o valor de 12, e com base nele chegar nos outros:
# Para N: 155/70 = 2,21 // 2,21*12 = 26,5, logo N =27
# Para O: 60/70 = 0,85 // 0,85*12 = 10,2, logo O = 10
# Para S: 180/70 = 2,57 // 2,57*12 = 25,7 logo S = 26

# Como podemos fazer isso?
  # 1. Usando o replace pelo tamanho não vai, pois ele só aceita um orgumento númerico:
#Error in avgscale * size : non-numeric argument to binary operator

tamanho = POS_XYZ$A

tamanho = gsub(pattern = "O", replacement = 10, x = tamanho)
tamanho = gsub(pattern = "C", replacement = 12, x = tamanho)
tamanho = gsub(pattern = "N", replacement = 27, x = tamanho)
tamanho = gsub(pattern = "S", replacement = 26, x = tamanho)

tamanho = as.numeric(tamanho)

with(POS_XYZ, plot3d(X,Y,Z, type = "s", size = tamanho/10))

#mudanca das cores

cores = POS_XYZ$A

cores = gsub(pattern = "O", replacement = "green", x = cores)
cores = gsub(pattern = "C", replacement = "black", x = cores)
cores = gsub(pattern = "N", replacement = "blue", x = cores)
cores = gsub(pattern = "S", replacement = "yellow", x = cores)


with(POS_XYZ, plot3d(X,Y,Z, type = "s", col = cores, size = tamanho/10))

#substituir os NA
is.na(POS_XYZ$A)
POS_XYZ$A[!(is.na(POS_XYZ$A))]
dim(POS_XYZ)
NOVO_POS_XYZ = POS_XYZ[!(is.na(POS_XYZ$A)),]
NOVO_POS_XYZ[1:4,]
dim(NOVO_POS_XYZ)
# Logo temos que pensar em outra forma, mas qual?

set.seed(101)
dd <- data.frame(x=rnorm(100),y=rnorm(100),z=rnorm(100),
                 c=rnorm(100),s=rnorm(100))

ss <- function(x) scale(x,center=min(x)-0.01,scale=diff(range(x))+0.02)
library(rgl)

cvec <- apply(colorRamp(c("red","blue"))(ss(dd$c))/255,1,
              function(x) rgb(x[1],x[2],x[3]))

with(dd,plot3d(x,y,z,type="s",radius=ss(s), col=cvec))

# TENTANDO NO MEU CÓDIGO:

POS_XYZ =  data.frame(X = numeric(),
                      Y =  numeric(),
                      Z = numeric(),
                      A = character(),
                      stringsAsFactors = F)
POS_XYZ
for(conta_linhas in 1:length(linhas_com_XYZ)){
  POS_XYZ[conta_linhas,] = unlist(strsplit(x = linhas_com_XYZ[conta_linhas], split = "\\s+"))[c(7:9,12)]
}


ss <- function(x) scale(x,center=min(x)-0.01,scale=diff(range(x))+0.02)
library(rgl)

cvec <- apply(colorRamp(c("red","blue"))(ss(POS_XYZ$A))/255,1,
              function(x) rgb(x[1],x[2],x[3]))

with(POS_XYZ,plot3d(X,Y,Z,type="s",radius=ss(s), col=cvec))

