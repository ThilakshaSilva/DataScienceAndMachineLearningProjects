library(twitteR)
library(tm)
library(wordcloud)
library(RColorBrewer)
library(e1071)
library(class)

### Create a Twitter App

## Regular Expression Review
args(grep)
grep('A', c('A','B','C','D','A'))

args(nchar)
nchar('helloworld')
nchar('hello world')

args(gsub)
gsub('pattern','replacement','hello have you seen the pattern here?')

## Text Manipulation
paste('A','B','C',sep='...')
substr('abcdefg',start=2,stop = 5)
strsplit('2016-01-23',split='-')

## Twitter Mining
# Step 1: Import Libraries
library(twitteR)
library(tm)
library(wordcloud)
library(RColorBrewer)

# Step 2: Search for Topic on Twitter
ckey <- "6uTe98KFulWW2io1qtSjYUuwW"
skey <- "vvynDY3vaKs9G2qUTsNNz9wNjB9aO0aTQaHovkWyajPZpZg3DD"
token <- "933321448852135936-NFiveAf89BxNvKTvgAzgf2lC6Kg4tgM"
sectoken <- "FnxFrCOesIEkH8XLTGRAaCmyBrMNLuS6y0nReluMKPFce"
setup_twitter_oauth(ckey, skey, token, sectoken)
#Returning tweets
soccer.tweets <- searchTwitter("statistics", n=500, lang="en")
#Grabbing text data from tweets
soccer.text <- sapply(soccer.tweets, function(x) x$getText())

# Step 3: Clean Text Data
soccer.text <- iconv(soccer.text, 'UTF-8', 'ASCII') #remove emoticons, only grab UTF-8 encoded characters
soccer.corpus <- Corpus(VectorSource(soccer.text)) #create a corpus

# Step 4: Create a Document Term Matrix
term.doc.matrix <- TermDocumentMatrix(soccer.corpus,
                                      control = list(removePunctuation = TRUE,
                                                     stopwords = c("statistics","http","https", stopwords("english")),
                                                     removeNumbers = TRUE,tolower = TRUE))
# Step 5: Check out Matrix
head(term.doc.matrix)
term.doc.matrix <- as.matrix(term.doc.matrix)

# Step 6: Get Word Counts
word.freqs <- sort(rowSums(term.doc.matrix), decreasing=TRUE) 
dm <- data.frame(word=names(word.freqs), freq=word.freqs)

# Step 7: Create Word Cloud
wordcloud(dm$word, dm$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2"))


