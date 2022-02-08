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

twitter_token <- rtweet::create_token(
  app = "JustinDefi",
  consumer_key = Sys.getenv("TWITTER_CONSUMER_API_KEY"),
  consumer_secret = Sys.getenv("TWITTER_CONSUMER_API_SECRET"),
  access_token <- Sys.getenv("TWITTER_ACCESS_TOKEN"),
  access_secret <- Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET"),
  set_renv = TRUE)

collection <- 'boredapeyachtclub'

# Retrieving specific data about single collection
r <- GET(paste("https://api.opensea.io/api/v1/collection/",collection, sep=''))
content <- fromJSON(prettify(r, indent = 4))

# Get Stats and contract details about Collection
stats <- content$collection$stats
contract <- content$collection$primary_asset_contracts

# Get description
description <- content$description

# Find out Twitter user
bored_ape_twitter <- content$collection$twitter_username

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



