library(ggplot2)
library(dplyr)
library(tidyr)
library(berryFunctions)
library(broom)
library(patchwork)
#Frequency of date
tiktok %>% 
  filter(Date > "2021-1-1")-> tiktok_19

since2021 <-ggplot(data = tiktok_19) + 
  geom_histogram(aes(x = Date),fill = "palegreen3")+
  ylab("Number of Posts")+
  ggtitle("Number of Posts per Day since 2021 ")+
  xlab("Month in 2021" )

whole<-ggplot(data = tiktok) + 
  geom_histogram(aes(x = Date),fill = "#f27eb2")+
  xlab("Year")+
  ylab("Number of Posts")+
  ggtitle("Number of Posts per Day")

may<-tiktok %>% 
  filter(Date > "2021-05-01") %>% 
  ggplot()+
  geom_histogram(aes(x = Date), fill = "wheat")+
  xlab("Day in May")+
  ylab("Number of Posts")+
  ggtitle("Number of Posts per Day since May 1st")
whole+since2021+may
#What day of the week is best for posting

tiktok$day <- weekdays(as.Date(tiktok$Date))
tiktok$month <- month(tiktok$Date)

ggplot(data = tiktok)+
  geom_bar(aes(x = day.fact), fill = "#559aba" )+
  ylab('Amount of Posts')+
  xlab("Day of the Week")+
  ggtitle("Amount of Posts for Each Day of the Week")
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
str(tiktok$day)
tiktok$day.fact<- factor(tiktok$day, ordered = TRUE, levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))

daymod <- lm(postLikes ~ day, data = tiktok)
summary(daymod)
#-----------------------------------------------------

##IGNORE DOES NOT WORK

#spotify
install.packages("Rtools")
install.packages("devtools")
library(devtools)
devtools::install_github('charlie86/spotifyr')
library(spotifyr)

Sys.setenv(SPOTIFY_CLIENT_ID = '2c09e3527a334afc97da84498476505f')
Sys.setenv(SPOTIFY_CLIENT_SECRET = '64ae11eb3efd429ebefcdbf7515846d5')

access_token <- get_spotify_access_token()

tiktok %>% 
  separate(postSoundtrack, c("Song", "Artist"), sep = "-")-> try



musicdata <- data.frame()

for(n in 1:nrow(try)){
  if(is.error(get_artist_audio_features(try$Artist[1]))== FALSE){
    ah <- get_artist_audio_features(try$Artist[n])
    if(is.error(ah %>% filter(track_name == try$Song[n])) == FALSE){
      ah %>% 
        filter(track_name == try$Song) -> ah3
      musicdata <- rbind(ah3, musicdata)
    }
  }
 
}

#-----------------------------------------------------------

'
most of the sentiment scores are pretty nuetral. 
'

library(dplyr)
library(tidytext)
library(stringi)
library(cowplot)

head(stop_words)

tiktok_words = tiktok %>% 
  select(userDisplayName, postDescription, trendingHashtag) %>% 
  unnest_tokens(input = postDescription, output = word, format = "text") %>% 
  anti_join(stop_words)

sentiment_words = get_sentiments("bing")
head(sentiment_words)

user_sentiment = tiktok_words %>% 
  inner_join(sentiment_words) %>%  
  group_by(userDisplayName, trendingHashtag) %>% 
  summarise(is_pos = sum(sentiment == "positive"),
            is_neg = sum(sentiment == "negative"),
            total_score = is_pos - is_neg)

head(user_sentiment)

user_sentiment %>% 
  ggplot()+
  geom_histogram(aes(x= total_score),fill = "palegreen4",bins = 25)+
  xlab("Total Score of Sentiment")+
  ylab("Number of Posts")+
  ggtitle("Total Sentiment Scores by Trending Hashtags")+
  facet_grid(trendingHashtag~.)

user_sentiment %>% 
  ggplot()+
  geom_area(aes(x= total_score, y = count(total_score) , fill = trendingHastags ),bins = 25)+
  xlab("Total Score of Sentiment")+
  ylab("Count")+
  ggtitle("Count of Total Sentiment Scores")+
  facet_grid(.~trendingHashtag)

library(wordcloud)
word_freq_df = tiktok_words %>% 
  count(word)

options(repr.plot.width = 12, repr.plot.height = 10)
wordcloud(words = word_freq_df$word, freq = word_freq_df$n, max.words = 100, random.color = T)


#-----------------------------------------------------------
'
Did videos using an original sound have more likes than videos not using an original sound? Did those users have more followes?

'

p1 <- tiktok %>% 
  group_by(original_sound) %>% 
  summarise(meanlikes = mean(postLikes)) %>% 
  ggplot()+
  geom_col(aes(x = as.character(original_sound), y =meanlikes), fill = c("cornflowerblue"))+
  xlab("Original Sound")+
  ylab("Mean Likes")+
  ggtitle("Mean Likes of Original Sound ")+
  scale_x_discrete(labels=c("0"= "no original sound", "1" = "original sound"))

p2<-tiktok %>% 
  group_by(original_sound) %>% 
  summarise(meanfollowers = mean(userFollowers)) %>% 
  ggplot()+
  geom_col(aes(x = as.character(original_sound), y =meanfollowers), fill = c("cornflowerblue"))+
  xlab("Original Sound")+
  ylab("Mean Followers")+
  ggtitle("Mean Followers of Users using Original Sound ")+
  scale_x_discrete(labels=c("0"= "no original sound", "1" = "original sound"))

p1+p2
#--------------------------------------------------------

#Comments blocked

tiktok %>% 
  filter(Date>dte-3) %>% 
  mutate(commentsblocked = ifelse(postComments==0, 1, 0)) %>% 
  group_by(commentsblocked) %>% 
  summarise(meanlikes = mean(postLikes)) %>% 
  ggplot()+
  geom_col(aes(x = as.character(commentsblocked), y = meanlikes), fill =  "#559aba")+
  ylab("Average Likes")+
  xlab("Comments")+
  scale_x_discrete(labels=c("0"= "comments allowed", "1" = "comments blocked"))+
  ggtitle("Average Likes of Comments Blocked vs Not Blocked")


