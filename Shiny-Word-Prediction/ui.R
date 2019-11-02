

library(shiny)

library(hash)

MaxWordCount <- 10
for (i in 1:MaxWordCount) {
    assign(paste0("dict",i),readRDS(paste0("dict",i,".RDS")))
}

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Text Prediciton App"),
  
  # Sidebar with a slider input for number of bins 
  mainPanel(
       textInput("InputText", "Write some text"),
       verbatimTextOutput("words")
    )
))
