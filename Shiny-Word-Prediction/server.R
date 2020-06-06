## ---------------------------
##
## Script name: server
##
## Purpose of script:
##
## Author: Henry Letton
##
## Date Created: 2020-11-06
##
## ---------------------------
##
## Notes: handles in put text and loads hash maps
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

shinyServer(function(input, output) {
   
  output$words <- renderText({
    
      text <- gsub("[^a-z' ]","",
                   gsub("( *)$","",tolower(input$InputText)))
      words <- strsplit(text, " ")
      WordCount <- length(words[[1]])
      
      sentence <- text
      
      pred <- NULL
      for (i in WordCount:1)  {
          if (text=="") {break}
          if (length(strsplit(sentence, " ")[[1]])<=MaxWordCount) {
              pred <- eval(parse(text=paste0("dict",i,'[["',sentence,'"]]')))
            if (!is.null(pred)) {
              break
            }
          }
          sentence <- gsub("^(.*?) ","",sentence)
      }
      
      
      if (is.null(pred)) {
          "No words or unknown word!"
      } else {pred}
      
  })
  
})
