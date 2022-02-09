library(taskscheduleR)

taskscheduler_create(taskname = "daily_update_bayc", rscript = "C:/Users/LK/Desktop/NFT Valuation/twitter_stats.R", 
                     schedule = "DAILY", starttime = format(Sys.time() + 50, "%H:%M"))
