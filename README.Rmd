---
title: "README"
author: "Emma Tuhabonye"
date: "11/26/2021"
output: html_document
---

# How to Go Viral on TikTok
### Introduction
Originally Musical.ly, Tiktok is a social media platform for creating, sharing and discovering short videos. It grew in popularity during the pandemic due to people being at home most of the time. With 689 million active users internationally, it is the most downloaded photo and video app in the Apple store globally.  (“What Is TikTok? ”) Simplified video creation and sharing makes it easy for users to contribute to content on the app. Videos can only be up to one minute, though recently TikTok added the ability to add up to 3 minute videos. As soon as the app opens a video will start playing, where a user can vertically scroll to engage with more content. Creators can use audio created on the app or download audio to use in their videos. A reason TikTok is so popular is the ability to duet and use other people’s sound. For individual creators, becoming famous on TikTok heavily depends on other people using one’s sound. Many times when people start using a sound, this starts a trend that traces back to the original creator. We were inspired to do this project because of how quickly people grew on the app compared to other apps we have seen. We investigate TikTok’s data for tendencies among popular posts and users.
### Data Collection
TikTok and other social media apps prioritize data privacy and exclusivity. These platforms do not openly share their data. To collect data from TikTok, we used Python to scrape TikTok’s website. Driven by the selenium python package that automates web browser interaction, we were able to scrape 5,000 TikTok posts. One of the main difficulties that selenium overcomes is that it allows scraping the dynamically generated content from TikTok. Our dataset includes 1,000 posts from each of the trending hashtags. At the time of scraping, these hashtags included #dinnerrecipe, #goodmemories, #myjewishheritage, #starwarsday, and #teachersoftiktok. Figure 1 highlights a sample of four observations scraped from TikTok, which contains the ‘post description’, ‘total post likes’, ‘total post comments’, ‘total post shares’, and ‘post date’ to name a few variables. In the end, it took about 1 hour to scrape each of the trending hashtags with a total of approximately 5 hours.
Although we wanted to fully automate the scraping process, TikTok’s website included an anti-scraping system that detected when a bot was scrolling through their website. In order to collect the links to all the posts, we had to manually scroll the trending pages and then locally save the html document to be later parsed with packages from python, such as beautiful soup. Fortunately, the dynamically generated content containing the post links was not removed from the DOM (Document Object Model) as we scrolled through the trending pages, so we were able to easily grab the links from these pages.
### Data Refactoring
One issue we saw with the dataset was that the numbers were posted as character values such as “1.7M” or “2.3B”. This posed a problem because we could not just use as.numeric(). Another problem we encountered was the postDate variable. The postDate variable was written in multiple different ways. Some of the dates were written in a format that was easily changed into as.Date() by R but some were character variables written in “1 week ago”. Finally, there was trouble with the postSoundtrack variable. We wanted to split up the song and the artist and also create an original sound variable. We define an original sound as one that was created on the app by any user. The creator of that sound did not have to be the owner of the sound.

<img src="C:\Users\emmat\Pictures\Figure1a.jpg">

<img src="C:\Users\emmat\Pictures\Figure1b.jpg">

###### Figure 1: Data snippets including highlighting variables and 4 observations
 
### Explored Questions
We explored several questions from TikTok’s data to identify trends among popular posts and users. To create a viral video we needed to figure out what days were the best to post, what kind of sentiment for captions appear on the trending page more, does using an original sound result in more likes or followers, how long do videos stay on the trending page, what attributes among a post and user were most important to become a verified user, and lastly does the use of hashtags increase engagement.
What kind of sentiments for captions appear on the trending page more? To answer this question we counted the number of words with positive and negative sentiments in each post and added them together to the total score. Then we created a histogram and say where most of the posts lie (Figure 3) . Most of the total scores were around zero or were not very positive or not very negative in sentiment. We then created a word cloud (Figure 2) to analyze what words were being said the most. The most common words were fyp and some of the hashtags we drew the data from.

<img src="C:\Users\emmat\Pictures\Figure2.jpg">

###### Figure 2: Word Cloud signifying the most prevalent words through 5,000 post descriptions/captions

<img src="C:\Users\emmat\Pictures\Figure3.jpg">

###### Figure 3: Sentiment scores for post descriptions grouped by trending hashtag
 
Does having an original sound result in more likes/followers? We defined an original sound as one that a user created on the TikTok app, whether that be from grabbing a sound provided by tiktok and modifying it, creating the sound from scratch, or importing their sound from another application. Users can use each other's original sounds so we did not differentiate between whether the original sound was their own or someone else's. A nonoriginal sound is a sound that a user got straight from the TikTok app. Based on Figure 4, we found that the mean amount of likes for those who used an original sound was higher than those who used a nonoriginal sound. It was similar for followers as well. Users that used an original sound had an average number of followers higher than those that did not use original sounds.

<img src="C:\Users\emmat\Pictures\Figure4.jpg">

###### Figure 4: Mean Likes of Original Sound vs. Not Original and Mean Followers using Original Sound vs. Not an Original Sound
Do Videos with Blocked Comments have more views? A creator may block comments because of hate comments or because they simply do not want other users to share their opinions on their post. Based on Figure 5, the average number of likes for a post with comments enabled was much smaller than the average number of likes for a post with comments blocked.

<img src="C:\Users\emmat\Pictures\Figure5.jpg">

###### Figure 5: Average Comments Blocked vs Not Blocked
How long do videos stay on the trending page? We noticed that although there are some videos from 2016, a large majority of the videos on the trending page were posted on that day or a couple days before. We drew that this meant there was a quick turnover for videos on the trending page.

<img src="C:\Users\emmat\Pictures\Figure6.jpg">

###### Figure 6: Posts per day from trending hashtags
 
We then examined what attributes among a post and user were most important to become a verified user? We created a logical regression with six independent variables, which include postLikes, postComments, postShares, userFollowers, userFollowing, and userLikes, to model the probability between verified and unverified. We found that postLikes (the number of likes on a post) and userFollowers (the number of followers of a user) were most statistically significant. Unsurprisingly, userFollowers had a positive coefficient signifying that verified users generally have more followers than unverified users. Surprisingly, postLikes had a negative coefficient. We thought the number of likes would be positively correlated to being verified as a user, but it’s the opposite. One possible reason for this is that many of the verified users (207 verified unique users) are businesses/organizations, rather than creators. For instance, in our dataset we identified Paper Magazine, Freeform, Nickelodeon, Buzzfeed, lsu, and Buffalo Wild Wings to name a few. These businesses/organizations generally use the platform for marketing and advertising purposes, and getting a business/organization verified is easier than getting an individual creator verified, where many creators rely on producing quality content with consistent user/follower engagement (Figure 5).

<img src="C:\Users\emmat\Pictures\Figure7.jpg">

###### Figure 7: Summary of Logistic Model
 
Lastly, we looked at whether the use of hashtags increases engagement. We define engagement as the number of likes on a post, where more likes yields higher engagement. First, we looked at the percentage of likes a video has over the total number of likes between verified and unverified users. Verified users’ posts under trending hashtags account for about 9 percent of their total likes, while unverified users’ posts account for about 1 percent of their total likes. So using trending hashtags for unverified users is a great way to attract more followers and gain more likes. Second, we performed a linear regression  to see if there was a correlation between the number of hashtags to the number of likes on a post. We added another column to our dataset identifying the number of hashtags for each post description. We found that postHashtags were statistically significant with a negative coefficient, indicating that the more hashtags a user adds to a video, the less engagement (post likes). Based on Figure 6, we see that adding only a few hashtags is best for increased engagement.

<img src="C:\Users\emmat\Pictures\Figure8.jpg">

###### Figure 8: Post Hashtags vs Post Likes, fit with linear regression model
 
### Conclusion
We identified key ways for a user to get more likes, more exposure, and hopefully become TikTok famous. By using between 2 and 9 hashtags, especially including trending hashtags, gaining followers, using an original sound, and not blocking comments, anyone can go viral on TikTok. Following our guide can help anyone become famous, but it's more about the quality of content based on society and related trends that truly attract interest and likes. Expanding this investigation to include Spotify data about songs used on TikTok could provide meaningful insights into the type of music used in posts in order to capture more post likes.
 
 
### References
“What Is TikTok? - The Fastest Growing Social Media App Uncovered.” Influencer Marketing Hub, 10 May 2021, influencermarketinghub.com/what-is-tiktok/.
