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

# Select collection of interest
collection <- 'boredapeyachtclub'

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



