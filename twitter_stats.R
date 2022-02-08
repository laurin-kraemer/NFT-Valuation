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

twitter_token <- rtweet::create_token(
  app = "JustinDefi",
  consumer_key = Sys.getenv("TWITTER_CONSUMER_API_KEY"),
  consumer_secret = Sys.getenv("TWITTER_CONSUMER_API_SECRET"),
  access_token <- Sys.getenv("TWITTER_ACCESS_TOKEN"),
  access_secret <- Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET"),
  set_renv = TRUE)