writeLines("It is part of my CNPq-funded project and seeks to make corpus tools and R accessible. If you have any doubts or wish to make any research contact please send me an email. Rodrigo de Lima-Lopes rll307@unicamp.br")

# Introduction ------------------------------------------------------------
#Project: Scraping YouTube Comments
#By: rll307
#Date: 2021-12-01

# Packages ----------------------------------------------------------------
library(magrittr)
library(jsonlite)
library(stringr)

# Variables ---------------------------------------------------------------
# Video ID
Video.ID <- "FvOO3Gysd7Q"
#File name
File.Name <- 'MourasComments'
#creating a system query
CMD <- str_glue("youtube-comment-downloader --youtubeid {Video.ID} --output {File.Name}.json")
# downloading  ---------------------------------------------------------------
cat(CMD) # Shows the command
system(CMD) # Actual download

# Importing as a dataframe
Comments <- stream_in(file("MourasComments.json"))


