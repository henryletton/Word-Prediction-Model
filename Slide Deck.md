Slide Deck - Word Prediction App
========================================================
author: Henry
date: 03/11/2019
autosize: true

The Pitch
========================================================

When typing on a mobile device, or many other devices, the speed of typing sentences can be slower than your thought process. This can cause irritation, frustation, and possibly even anger at technology.   
**BUT NO MORE!!**  
With this new text prediction application, the next word will be suggested for you almost instantly. This will save you valueable seconds.

The App
========================================================

The prototype app is located here: <https://hennersmcgee.shinyapps.io/Shiny-Word-Prediction/>.  

This application will read any text entered into it, and using the last 10 words or down to the last word, will return the most likely next word.  

It is so quick, because it has a series of dictionarys (ten, one for each amount of words) and it simply queries them without and complicated processing.

The Algorithm
========================================================

To create the series of dictionarys, the algorithm:  

1)  Imports a selection of blogs/news/twitter text.  
2)  Extracts the word list for each line.  
3)  For each neighbouring two words, finds the most likely second word given the first.  
4)  Repeats the above step for 2-10 preseeding words.  
5)  Uses this ten data sets to create dictionarys for quick access to a following word.  

Further Development
========================================================

There were a few problems I ecounted but didn't have time to develop solutions for. These are listed below:

- Capital letters were ignored for this, and all predictions are lower case.  
- Spelling or existance of words, although if a word or sequence of words exists less than 5 times, then it is not kept for the dictionaryd.  
- There was a size limit to how much text I could build my model off, so I had to sample the full data.
