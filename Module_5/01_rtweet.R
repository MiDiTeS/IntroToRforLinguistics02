writeLines("It is part of my CNPq-funded project and seeks to make corpus tools and R accessible. If you have any doubts or wish to make any research contact please send me an email. Rodrigo de Lima-Lopes rll307@unicamp.br")

# Packages ----------------------------------------------------------------
library(rtweet)

# Doing research on topics--------------------------------------------------
all.trends <- trends_available()
br.trends <- get_trends(woeid = 23424768)


# getting some tweets -----------------------------------------------------
#Option 1

stream_tweets('Grammy', 
              timeout = 100, #in seconds
              file_name = 't01',#it saves a file, not a variable
              parse = FALSE,
              verbose = TRUE
              ) 

# For a given period of time
my.Tweets <- parse_stream("t01.json")

# By the number of tweets
my.Tweets2 <- search_tweets(
  "Grammy", n = 1000, include_rts = TRUE)

# Getting a timeline
boulos <- get_timeline("GuilhermeBoulos", n = 1000)

# Getting the followers
boulos.flw <- get_followers("GuilhermeBoulos",
                            verbose = TRUE,n = 1000)

# Some information about the users
boulos.flw2 <- boulos.flw[1:100,]
info <- lookup_users(boulos.flw2$user_id)

# users who tweet about a topic
users <- search_users("Grammy", n = 1000)

# Comparing two politicians
presidentes <- get_timelines(c("jairbolsonaro", "LulaOficial"), n = 3200)

# Plotando os presidentes

presidentes %>%
  dplyr::filter(created_at > "2021-08-01") %>%
  dplyr::group_by(screen_name) %>%
  ts_plot("days", trim = 7L) +
  ggplot2::geom_point() +
  ggplot2::theme_minimal() +
  ggplot2::theme(
    legend.title = ggplot2::element_blank(),
    legend.position = "bottom",
    plot.title = ggplot2::element_text(face = "bold")) +
  ggplot2::labs(
    x = NULL, y = NULL,
    title = "Frequency of Twitter statuses posted by (Ex-)Brazilian Presidents",
    subtitle = "Twitter status (tweet) counts aggregated by day from August 2021",
    caption = "\nSource: Data collected from Twitter's REST API via rtweet"
  )


















