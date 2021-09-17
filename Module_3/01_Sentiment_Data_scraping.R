# Introduction ------------------------------------------------------------
# Name: Replication of Lima-Lopes (2020)
# Source for replication: https://revistas2.uepg.br/index.php/muitasvozes/article/view/15506
# Written by Rodrigo de Lima-Lopes at rll307@unicamp.br
writeLines("It is part of my CNPq-funded project and seeks to make corpus tools and R accessible. If you have any doubts or wish to make any research contact please send me an email. Rodrigo de Lima-Lopes rll307@unicamp.br")

# packages ----------------------------------------------------------------
library(rvest)
library(purrr)
library(xml2) 
library(stringr)
library(dplyr)

# Scraping ----------------------------------------------------------------
# Each newspaper is going to need a different set of functions so we will need a section for each newspaper


# Daily Star --------------------------------------------------------------

# Importing the file good for data retrieving
articles_DS.df <- readr::read_csv("Module_3/articles_DS.csv")
article <- as_vector(articles_DS.df)

# Function for data scraping

map_dfr(.x = article,
        .f = function(x){
          tibble(Title = read_html(x) %>%
                   html_nodes("title") %>%
                   html_text(),
                 Content = read_html(x) %>%
                   html_nodes("p") %>%
                   html_text())}) -> DS.df

DS.df <- aggregate(Content ~ Title, DS.df, FUN = paste, collapse = ' ')
DS.df$site <- 'DailyStar'
DS.df$ID <- paste0('DS', 1:length(DS.df$site))

# Telegraph ---------------------------------------------------------------

articles_TT.df <- readr::read_csv('Module_3/articles_TT.csv')
article <- as_vector(articles_TT.df)

map_dfr(.x = article,
        .f = function(x){
          tibble(Title = read_html(x) %>%
                   html_nodes('h1') %>%
                   html_text(),
                 Content = read_html(x) %>%
                   html_nodes("p") %>%
                   html_text())}) -> TT.df
TT.df <- TT.df %>%
  group_by(Title) %>%
  summarise(Content = str_c(Content, collapse = " "),
            .groups = 'drop')
TT.df$site <- 'TheTelegraph'
TT.df$ID <- paste0('TT', 1:length(TT.df$site))

# The Sun -----------------------------------------------------------------

articles_TS.df <- readr::read_csv("Module_3/articles_TS.csv")
article <- as_vector(articles_TS.df)

map_dfr(.x = article,
        .f = function(x){
          tibble(Title = read_html(x) %>%
                   html_nodes('title') %>%
                   html_text(),
                 Content = read_html(x) %>%
                   html_nodes(xpath = "//div[@class='article__content']") %>%
                   html_text(),
                 Site = "TheSun"
          )}) -> TS.df
TS.df$ID <- paste0('TS', 1:length(articles_TS.df$Address))


# For saving each file as a Data Frame ----------

TSt.df <- data.frame(TS.df) #Necessary due to compatibility

my.files <- as_vector(TSt.df$ID) # Making a vector for the indexing

location <- list() # empty list

for (i in 1:length(my.files)) { # looping for locating each file in my data frame
  location[[i]] <- grep(my.files[i], TSt.df[,4])
}

for (i in 1:length(my.files)) { # gets each location in my files
  file.name <- paste(my.files[i], ".txt", sep = "") #paste the name of ID as file name
  sink(file.name) # Open the connection to a empty file
  print(as_vector(TSt.df[location[[i]],2])) # prints each line as a vector into the file
  gsub("\r?\n|\r", " ", file.name) 
  sink()
}













