## ---------------------------
##
## Script name: ui
##
## Purpose of script:
##
## Author: Henry Letton
##
## Date Created: 2020-11-06
##
## ---------------------------
##
## Notes: app interface design
##   
##
## ---------------------------

# Load libraries
library(shiny)

library(hash)

MaxWordCount <- 10
for (i in 1:MaxWordCount) {
    assign(paste0("dict",i),readRDS(paste0("dict",i,".RDS")))
}

# Define UI for application that draws a histogram
shinyUI(navbarPage(theme = shinythemes::shinytheme("flatly"),
  
  # Application title
  "Text Predicton",
  tabPanel("App",
           h4("As you type in the text box below, the next word will be predicted for you."),
           h4("This will work regardless of punctuation and capitalisation, but does not cope with spelling errors."),
           h4("The more words you type, the better the prediciton."),
           h4(" "),
  # Sidebar with a slider input for number of bins 
    mainPanel(
         textInput("InputText", "Write some text here:"),
         verbatimTextOutput("words")
      )
  ),
  # Description of application
  tabPanel("About",
           h1("About Dashboard"),
           h2("The Concept"),
           h4("This dashboard was a project for an online Coursera specialisation offered by John Hopkins University."),
           tags$a(href="https://www.coursera.org/specializations/jhu-data-science", "Link here"),
           h4("The task was to build a word prediction app that reads typed text and returns a likely next word."),
           h2("The Build"),
           h4("The starting training data sets were a series of twitter, news, and blog posts."),
           h4("This was used to find the number of occurences of precedding word and following word pairs, and determine the most common."),
           h4("This word was saved to a hash map, with the following word as a value."),
           h4("Those two steps were repeated with more and more preceeding words, until ten hash maps were built."),
           h4("These hash maps sit behind this application for quick retrieval of data."),
           h2("The Algorithm"),
           h4("When you type words in, the following steps occur:"),
           tags$ol(
             tags$li("The text is cleaned and the last 10 words are isolated, or less if fewer words typed."), 
             tags$li("These words are then run through a hash map to see if a match is found."), 
             tags$li("If no match is found, than the first word in the sequence is removed and this shorter sequence os run through a different hash map."), 
             tags$li("The is repeated until either a match is found or the last word has been tried."), 
             tags$li("The predicted word is then shown or 'No words or unknown word!'")
           ),
           h2("Further Development"),
           h4("There were several problems encounted, where a solution was not developed in time:"),
           tags$ul(
             tags$li("Capital letters were ignored for this, and all predictions are lower case."), 
             tags$li("There was no verification that words were real or spelt correctly. However, 
                     they had to feature at lease 5 times to be included, and this did allow for colloquialisms."), 
             tags$li("The prediciton model required vast amounts of text to build and my system/time limitations restricted the build quality."), 
             tags$li("The model is deterministic and so can get stuck in loops.")
           ),
           tags$a(href="https://github.com/HennersMcGee/Word-Prediction-Model", "Github Repository!")
  )
))
