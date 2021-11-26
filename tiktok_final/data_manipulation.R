##Data manipulation

library(readxl)
tiktok_trending_dataset <- read_excel("C:/Users/emmat/Documents/QAC 211/tiktok_final/tiktok-trending-dataset.xlsx")

require(dplyr)
require(Dict)
require(stringi)

#date data collected: 
dte = as.Date("2021-5-6")
tiktok_trending_dataset %>% 
  mutate(original_sound = ifelse(grepl("original sound", tiktok_trending_dataset$postSoundtrack, ignore.case =  T), 1, 0)) ->tiktok_trending_dataset

#changes number from ex."1.7M" to numeric
tiktok_trending_dataset %>% 
  mutate(postLikes = stri_replace_all(postLikes, replacement="E3", fixed="K") %>%
           stri_replace_all(replacement = "E6", fixed="M") %>%
           as.numeric(),
         postComments = stri_replace_all(postComments, replacement="E3", fixed="K") %>%
           stri_replace_all(replacement = "E6", fixed="M") %>%
           as.numeric(),
         postShares = stri_replace_all(postShares, replacement="E3", fixed="K") %>%
           stri_replace_all(replacement = "E6", fixed="M") %>%
           as.numeric(),
         userFollowers = stri_replace_all(userFollowers, replacement="E3", fixed="K") %>%
           stri_replace_all(replacement = "E6", fixed="M") %>%
           as.numeric(),
         userLikes = stri_replace_all(userLikes, replacement="E3", fixed="K") %>%
           stri_replace_all(replacement = "E6", fixed="M") %>%
           as.numeric())-> tiktok

tiktok$Date<-tiktok$postDate
tiktok$Date[tiktok$Date == "1w ago"]<- "7d ago"

tiktok %>% 
  mutate(numeric_x = stri_replace_all(Date, replacement = "", fixed = "d ago"),
         date1 = dte - as.numeric(numeric_x),
         date2 = as.Date(Date, "%Y-%m-%d"),
         date3 = as.Date(Date, "%m-%d"),
         Date = coalesce(date1,date2,date3))-> tiktok
tiktok$Date[is.na(tiktok$Date)]<- dte

tiktok = select(tiktok,-numeric_x, -date1, -date2, -date3)

tiktok$userVerified<- ifelse(tiktok$userVerified, 1, 0)

tiktok<- as.data.frame(tiktok)



remotes::install_github("JBGruber/rwhatsapp")
require(rwhatsapp)
df <- rwhatsapp::rwa_read(tiktok$postDescription)
#> Warning in readLines(x, encoding = encoding, ...): incomplete final line found
#> on '_chat.txt'
df