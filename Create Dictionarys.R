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
library(hash); library(dplyr); library(tidyr); library(data.table)

#Read in data 
setwd('..')
dt <- c(readLines("./final/en_US/en_US.blogs.txt")[1:100000],
        readLines("./final/en_US/en_US.news.txt"),
        readLines("./final/en_US/en_US.twitter.txt")[1:100000])
setwd('./Word-Prediction-Model')

## Get data frame of words and line breaks

dt <- data.frame(line=dt); dt$LineNum <- rownames(dt)
dt <- data.table(dt)
saveRDS(dt,file="dt.RDS")

wordsDT <- dt[,c(word=strsplit(gsub("[^a-z' ]","",tolower(line)), "( +)")), 
               by = LineNum]

rm(dt)
wordsDT <- data.frame(wordsDT)

wordsDT <- wordsDT %>%
    dplyr::select(word,LineNum) %>%
    dplyr::filter(grepl("^[a-z]",word)) %>%
    dplyr::filter(grepl("[a-z]$",word)) #%>%
    # dplyr::mutate(word1=lag(word,1),word2=lag(word,2),
    #               word3=lag(word,3),word4=lag(word,4),
    #               word5=lag(word,5),word6=lag(word,6),
    #               word7=lag(word,7),word8=lag(word,8),
    #               word9=lag(word,9),word10=lag(word,10))

saveRDS(wordsDT,file="wordsDT.RDS")

            
## Create dictionarys


for (i in 4:numDicts) {
    
    wordNumb <- c()
    for (j in 1:i) { wordNumb[j] <- paste0("word",j)  } 
    wordNumb <- rev(wordNumb)

    # Get data set with word and prediction as columns
    wordsPred <- wordsDT %>% 
        dplyr::mutate(word1=lag(word,1),word2=lag(word,2),
                      word3=lag(word,3),word4=lag(word,4),
                      word5=lag(word,5),word6=lag(word,6),
                      word7=lag(word,7),word8=lag(word,8),
                      word9=lag(word,9),word10=lag(word,10)) %>%
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
    
    #assign(paste0("wordsPred",i),wordsPred)
    rm(wordsPred)
    #assign(paste0("dict",i),dict)
    #rm(dict)
    
    saveRDS(get(paste0("dict")),file=paste0("./Shiny-Word-Prediction/dict",i,".RDS"))
    
}

# dict1b <- readRDS("./Shiny-Word-Prediction/dict")
# saveRDS(get(paste0("dict","1")),file=paste0("./Shiny-Word-Prediction/dict.RDa"))
# dict1b <- readRDS("./Shiny-Word-Prediction/dict.RDa")

