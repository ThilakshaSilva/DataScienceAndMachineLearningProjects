# Capstone Project - Moneyball Project 
# In this project I help the 'Oakland A Baseball Team' to recruit three under-valued players to replace three lost players.

batting <- read.csv('Batting.csv')
head(batting)
str(batting)
batting$AB[1:5]
head(batting$X2B)

# Feature Engineering
# Batting Average
batting$BA <- batting$H / batting$AB
tail(batting$BA,5)
#On Base Percentage
batting$OBP <- (batting$H + batting$BB + batting$HBP) / (batting$AB + batting$BB + batting$HBP + batting$SF)
#Slugging Percentage
batting$X1B <- batting$H - batting$X2B - batting$X3B - batting$HR
batting$SLG <- (batting$X1B + 2*batting$X2B + 3*batting$X3B + 4*batting$HR) / batting$AB
str(batting)

# Merging Salary Data with Batting Data
sal <- read.csv('Salaries.csv')
summary(sal)
summary(batting)
batting <- subset(batting, yearID >= 1985)
summary(batting)
combo <- merge(batting,sal,by=c('playerID','yearID'))
summary(combo)

# Analyzing the Lost Players
three <- c('giambja01', 'damonjo01', 'saenzol01')
lost_players <- subset(combo, playerID %in% three)
lost_players <- subset(lost_players, yearID == 2001)
lost_players <- lost_players[,c('playerID','H','X2B','X3B','HR','OBP','SLG','BA','AB')]
head(lost_players)

# Replacement Players
library(dplyr)
library(ggplot2)
avail.players <- filter(combo, yearID == 2001)
ggplot(avail.players, aes(OBP,salary)) + geom_point()
avail.players <- filter(avail.players,salary < 8000000,OBP > 0)
avail.players <- filter(avail.players,AB >= mean(lost_players$AB),OBP > mean(lost_players$OBP))
possible <- head(arrange(avail.players,desc(OBP)),10)
possible <- possible[,c('playerID','OBP','AB','salary')]
possible
newplayers <- possible[2:4,]
sum(newplayers$salary) # < 15million

