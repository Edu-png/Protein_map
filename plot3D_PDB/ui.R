#Autor: Leandro Martins de Freitas
#versao: 1
#data: 10/Nov/2022

library(shiny)
library(rgl)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Plot 3D"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
          sidebarPanel(
            titlePanel("Pocket map 1.0"),
            tags$hr(),
            textInput('txt',"Input PDB ID:"),
            h5("Such as '1fin' or '1mbd'"),
            tags$hr(),
            fileInput('file', "Upload your file:"),
            h5("Max file size to upload is 5 MB"),
            sliderInput('slider', 'Cutoff value:',
                        min= 0, max =5, value = 3),
            h5("Explanation of the cut-off value"),
            tags$hr(),
            textInput('txt',"Put your e-mail:"),
            checkboxInput('header', 'I want to be notified about updates to the tool by email'),
        ),

        # Show a plot of the generated distribution
        mainPanel(
         # hr("how do we get the plot inside this app window rather than in a popup?"),
          
          rglwidgetOutput("plot",  width = 800, height = 600)
        )
    )
))
