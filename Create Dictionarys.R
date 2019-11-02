## ---------------------------
##
## Script name: Create Dictionarys
##
## Purpose of script:
##
## Author: Henry Letton
##
## Date Created: 2019-11-02
##
## ---------------------------
##
## Notes:
##   
##
## ---------------------------

## User Inputs
numDicts <- 10
minOcc <- 5

#load libraries
library(hash); library(dplyr); library(tidyr)

#Read in data 
setwd('..')
dt <- c(readLines("./final/en_US/en_US.blogs.txt"),
        readLines("./final/en_US/en_US.news.txt"),
        readLines("./final/en_US/en_US.twitter.txt"))
setwd('./Word-Prediction-Model')

## Get data frame of words and line breaks
#empty lists
wordList <- c()
lineLength <- c()
#loop through lines to get long list of words
lineNum <- 1
for (line in dt[lineNum:length(dt)]) {
    words <- strsplit(gsub("[^a-z' ]","",tolower(line)), "( +)")
    wordList <- c(wordList,unlist(words[[1]]))
    lineLength[lineNum] <- length(words[[1]])
    lineNum <- lineNum+1
}
#get data frame for words
wordsDT <- data.frame(word=wordList)
saveRDS(wordList,file="wordList.RDS")
rm(wordList)
rm(dt)

#create field in word data set signifying when there's a new line
TotalWords <- length(wordsDT$word)
LineN <- 1
wordsDT$NewLine <- 0
numb1 <- 1
for (i in numb1:length(lineLength)) {
    if (LineN<=TotalWords ) {wordsDT$NewLine[LineN] <- 1}
    LineN <- LineN + lineLength[i]
    numb1 <- numb1+1
}
saveRDS(lineLength,file="lineLength.RDS")
rm(lineLength)

wordsDT <- wordsDT %>%
    dplyr::mutate(LineNum=cumsum(NewLine)) %>%
    dplyr::select(word,LineNum) %>%
    dplyr::filter(grepl("^[a-z]",word)) %>%
    dplyr::filter(grepl("[a-z]$",word)) %>%
    dplyr::mutate(word1=lag(word,1),word2=lag(word,2),
                  word3=lag(word,3),word4=lag(word,4),
                  word5=lag(word,5),word6=lag(word,6),
                  word7=lag(word,7),word8=lag(word,8),
                  word9=lag(word,9),word10=lag(word,10))

saveRDS(wordsDT,file="wordsDT.RDS")
            
## Create dictionarys



for (i in 1:numDicts) {
    
    wordNumb <- c()
    for (j in 1:i) { wordNumb[j] <- paste0("word",j)  } 
    wordNumb <- rev(wordNumb)

    # Get data set with word and prediction as columns
    wordsPred <- wordsDT %>% 
        # dplyr::select(word,LineNum) %>%
        # dplyr::filter(grepl("^[a-z]",word)) %>%
        # dplyr::filter(grepl("[a-z]$",word)) %>%
        # dplyr::mutate(word1=lag(word,1),word2=lag(word,2),
        #               word3=lag(word,3),word4=lag(word,4),
        #               word5=lag(word,5),word6=lag(word,6),
        #               word7=lag(word,7),word8=lag(word,8),
        #               word9=lag(word,9),word10=lag(word,10)) %>%
        tidyr::unite(allwords, wordNumb, sep=" ") %>%
        dplyr::filter(LineNum==lag(LineNum,i)) %>%
        dplyr::group_by_at(c("word","allwords")) %>%
        dplyr::summarise(count=n()) %>%
        #tidyr::unite(allwords, wordNumb, sep=" ") %>%
        dplyr::group_by_at("allwords") %>%
        dplyr::arrange(desc(count)) %>%
        slice(1) %>%
        dplyr::filter(count>=minOcc)
 

    # Create dictionary
    dict <- hash()
    for (j in 1:length(wordsPred$word)) {
        dict[[paste0(wordsPred$allwords[j])]] <- paste0(wordsPred$word[j])
    }
    
    assign(paste0("wordsPred",i),wordsPred)
    rm(wordsPred)
    assign(paste0("dict",i),dict)
    rm(dict)
    
    saveRDS(get(paste0("dict",i)),file=paste0("./Shiny-Word-Prediction/dict",i,".RDS"))
    
}

# dict1b <- readRDS("./Shiny-Word-Prediction/dict")
# saveRDS(get(paste0("dict","1")),file=paste0("./Shiny-Word-Prediction/dict.RDa"))
# dict1b <- readRDS("./Shiny-Word-Prediction/dict.RDa")

