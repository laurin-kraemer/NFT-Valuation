# Import libraries
library(httr)
library(usethis)
library(jsonlite)
library(twitteR)
library(tm)
library(dplyr)
library(tidytext)
library(tidyr)
library(tidyverse)
library(ggplot2)
library(jsonlite)
library(rjson)
library(rtweet)
library(stringr)

# Authentificate Twitter

consumer_key <- Sys.getenv("TWITTER_CONSUMER_API_KEY")
consumer_secret <- Sys.getenv("TWITTER_CONSUMER_API_SECRET")
access_token <- Sys.getenv("TWITTER_ACCESS_TOKEN")
access_secret <- Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET")

# Authenticate Token for rtweet
twitter_token <- rtweet::create_token(
  app = "JustinDefi",
  consumer_key = consumer_key,
  consumer_secret = consumer_secret,
  access_token <- access_token ,
  access_secret <- access_secret,
  set_renv = TRUE)

# Authenticate twittR
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)


collection_stats <- function(collection) {
  # Retrieving specific data about single collection
  r <- GET(paste("https://api.opensea.io/api/v1/collection/",collection, sep=''))
  content <- fromJSON(prettify(r, indent = 4))
  
  # Get Stats and contract details about Collection
  stats <- content$collection$stats
  contract <- content$collection$primary_asset_contracts
  
  # Get description
  description <- content$collection$primary_asset_contracts[[1]]$description
  
  # Token Standard
  token_standard <- content$collection$primary_asset_contracts[[1]]$schema_name
  
  # Date created
  date_created <- content$collection$primary_asset_contracts[[1]]$created_date
  date_created <- as.POSIXct(date_created, format="%Y-%m-%dT%H:%M:%S", tz="UTC")
  
  # Extract Year/Month/Date
  date_created <- strftime(date_created, format="%Y-%m-%d")
  
  # Find out Twitter user
  twitter_user <- content$collection$twitter_username
  
  # Collection Size
  n_pieces <- stats$total_supply
  
  # Number of Owners
  n_owners <- stats$num_owners
  
  # Floor Price
  floor_price <- stats$floor_price
  
  # Sales - One day
  n_day_sales <- stats$one_day_sales
  
  # Average price - One day 
  day_avg_price <- format(round(stats$one_day_average_price, 3), nsmall = 3) 
  
  # Sales - seven days
  n_week_sales <- stats$seven_day_sales
  
  # Average price - seven days
  week_avg_price <- format(round(stats$seven_day_average_price, 3), nsmall = 3) 
  
  # Sales - Last 30 Days
  n_month_sales <- stats$thirty_day_sales
  
  # Average Price - Last 30 Days
  avg_30_days <- format(round(stats$thirty_day_average_price, 3), nsmall = 3) 
  
  # Market Cap
  market_cap <- format(round(stats$market_cap, 1), nsmall = 0) 
  
  # Get Twitter User Object
  user <- getUser(twitter_user)
  
  # Followers count
  n_follower <- followersCount(user)
  
  # Is the user verified?
  verified <- verified(user)
  
  # Get the recent tweets of the account
  user_timeline <- userTimeline(user = user, n=30, maxID=NULL, sinceID=NULL, includeRts=TRUE,  excludeReplies=FALSE)
  
  # Convert to dataframe
  user_timeline <- twListToDF(user_timeline)
  
  # Custom stop words can be added to the lexicon like that
  custom_stop_words <- bind_rows(tibble(word = c("t.co", "https","nft", "nfts"),  
                                        lexicon = c("custom")), 
                                 stop_words)
  
  # Visualize
  freq_hist <- user_timeline %>%
    unnest_tokens(word,text) %>%
    anti_join(custom_stop_words) %>%
    count(word, sort=TRUE) %>%
    mutate(word=reorder(word, n)) %>%
    top_n(10) %>%
    ggplot(aes(word, n))+
    geom_col()+
    xlab(NULL)+
    coord_flip()
  
  print(freq_hist)
  
  freq_hist <- user_timeline %>%
    unnest_tokens(word,text) %>%
    anti_join(custom_stop_words) %>%
    count(word, sort=TRUE) %>%
    mutate(word=reorder(word, n))
  
  
  freq_hist$word <- as.character(freq_hist$word)
  
  tweet <- paste(paste('@',twitter_user, sep=""), "uses", gsub(" ", "", paste("#", token_standard)), "as #NFT token standard.", "The #collection has a #floor price of", floor_price, "ETH and had",n_day_sales, "Sales in the last day.", "#MarketCap is now",market_cap,"#Ethereum",gsub(" ", "", paste("#", freq_hist$word[1])), gsub(" ", "", paste("#", freq_hist$word[2])), gsub(" ", "", paste("#", freq_hist$word[3])),gsub(" ", "", paste("#", freq_hist$word[4])),gsub(" ", "", paste("#", freq_hist$word[5])), gsub(" ", "", paste("#", freq_hist$word[6])),gsub(" ", "", paste("#", freq_hist$word[7])), "#SeaHorseArmy")
  return(tweet)
  
}


# Select collection of interest
collection <- c('boredapeyachtclub','cryptopunks')

for (c in collection){
  tweet <- collection_stats(collection = c)
  post_tweet(
    status = tweet,
    media = NULL,
    token = twitter_token,
    in_reply_to_status_id = NULL,
    destroy_id = NULL,
    retweet_id = NULL,
    auto_populate_reply_metadata = FALSE
  )
}



