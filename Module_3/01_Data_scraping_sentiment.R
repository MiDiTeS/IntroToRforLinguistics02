# Introduction ------------------------------------------------------------
# Name: Replication of Lima-Lopes (2020)
# Source for replication: https://revistas2.uepg.br/index.php/muitasvozes/article/view/15506
# Written by Rodrigo de Lima-Lopes at rll307@unicamp.br
writeLines("It is part of my CNPq-funded project and seeks to make corpus tools and R accessible. If you have any doubts or wish to make any research contact please send me an email. Rodrigo de Lima-Lopes rll307@unicamp.br")

# packages ----------------------------------------------------------------
library(rvest)
library(purrr)
library(xml2) 
library(readr)
library(stringr)
library(dplyr)

# Scraping ----------------------------------------------------------------
# Each newspaper is going to need a different set of functions so we will need a section for each newspaper


# Daily Star --------------------------------------------------------------

# Importing the file good for data retrieving
articles_DS.df <- read_csv("Module_3/articles_DS.csv")
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

# The Sun -----------------------------------------------------------------

articles_TS.df <- read_csv("Module_3/articles_TS.csv")
article <- as_vector(articles_TS.df)

map_dfr(.x = article,
        .f = function(x){
          tibble(Title = read_html(x) %>%
                   html_nodes("title") %>%
                   html_text(),
                 Content = read_html(x) %>%
                   html_nodes(xpath = "//div[@class='article__content']") %>%
                   html_text(),
                 Site = "TheSun")}) -> TS.df








