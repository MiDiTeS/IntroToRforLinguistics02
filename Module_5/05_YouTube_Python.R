writeLines("It is part of my CNPq-funded project and seeks to make corpus tools and R accessible. If you have any doubts or wish to make any research contact please send me an email. Rodrigo de Lima-Lopes rll307@unicamp.br")

writeLines("This script is largely inspired by the work of Silas Gonzaga (http://sillasgonzaga.com/post/topic-modeling-nathalia-arcuri/), to whom all the credit should be given")

# Introduction ------------------------------------------------------------
#Project: Scraping YouTube captions
#By: rll307
#Date: 2021-12-01

# Packages ----------------------------------------------------------------

library(reticulate)
reticulate::use_python("/usr/local/bin/python3",required = TRUE)
library(tidyverse)
library(magrittr)
library(formattable)
library(purrr)
options(scipen = 999)
library(stringr)

# Creating the base command -----------------------------------------------
# Defining the fields
fields_raw <- c("id", "title", "alt_title", "creator", "release_date",
                "timestamp", "upload_date", "duration", "view_count",
                "like_count", "dislike_count", "comment_count")

# Defining the fields to be applied to the command
fields <- fields_raw %>% 
  map_chr(~paste0("%(", ., ")s")) %>% 
  # use &&& as field separator
  paste0(collapse = "&&&") %>% 
  # add quotation marks at the end and begging of the string
  paste0('"', ., '"')

# Video URL
# We can use both a video or an entire channel
channel_url <- "https://www.youtube.com/channel/UCynXCso-wU6E4V-DnsHU7mA"

# creating the query
cmd_ytdl <- str_glue("youtube-dl -o {fields} -i -v -w --skip-download --write-auto-sub --sub-lang pt --sub-format vtt {channel_url}")

Sub.folder <- "subtitles"
fs::dir_create(Sub.folder)

cmd <- str_glue("cd {Sub.folder} && {cmd_ytdl}")
system(cmd)


# Cleaning the data -------------------------------------------------------
my.captions <- dir(Sub.folder, pattern = '*.vtt', full.names = TRUE)
source_python("caption_to_vector.py")
source("functions.R")

df <- my.captions %>% 
  map_df(caption_to_df) %>% 
  select(-comment_count) %>% 
  mutate(upload_date = lubridate::ymd(upload_date)) %>% 
  mutate_at(vars(duration:dislike_count), as.numeric)









