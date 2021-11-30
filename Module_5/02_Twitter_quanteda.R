writeLines("It is part of my CNPq-funded project and seeks to make corpus tools and R accessible. If you have any doubts or wish to make any research contact please send me an email. Rodrigo de Lima-Lopes rll307@unicamp.br")

# Introduction ------------------------------------------------------------
#Project: Twitter and Quanteda
#Objective: 
#By: rll307
#Date: 24/Nov/2021 (Wed)
#Path: Exploratory Twitter Analysis

# Packages ----------------------------------------------------------------
library(rtweet)
library(quanteda)
library(quanteda.textstats)
library(quanteda.textplots)
library(ggplot2)

# Data --------------------------------------------------------------------
LI <- subset(presidentes, screen_name == "LulaOficial")
LI.t <- LI$text

JB <- subset(presidentes, screen_name != "LulaOficial")
JB.t <- JB$text

# Doing some kwic from the vectors
kwic(JB.t,"Brasil") |>
  DT::datatable()

kwic(LI.t,"Brasil") |>
  DT::datatable()


# Creating DFMs -----------------------------------------------------------
# To lower
LI.lower <- char_tolower(LI.t)
JB.lower <- char_tolower(JB.t)

# creating a tokens
JB.tok <- tokens(JB.lower, remove_punct = TRUE) 
LI.tok <- tokens(LI.lower, remove_punct = TRUE) 

# Now the DFMs
JB.dfm <- dfm(JB.tok,
              verbose = TRUE) |> 
  dfm_remove(stopwords("portuguese"),
             verbose = TRUE)

LI.dfm <- dfm(LI.tok,
              verbose = TRUE) |> 
  dfm_remove(stopwords("portuguese"),
             verbose = TRUE)

# Some plotting:
theme_set(theme_minimal())
textstat_frequency(LI.dfm, n = 50) %>% 
  ggplot(aes(x = rank, y = frequency)) +
  geom_point() +
  labs(x = "Frequency rank", y = "Term frequency")

theme_set(theme_minimal())
textstat_frequency(JB.dfm, n = 50) %>% 
  ggplot(aes(x = rank, y = frequency)) +
  geom_point() +
  labs(x = "Frequency rank", y = "Term frequency")

# Now let us create a wordlist

LI.wl <- textstat_frequency(LI.dfm)
View(LI.wl)
JB.wl <- textstat_frequency(JB.dfm)
View(JB.wl)

# and a tdif analysis
# One as an example
LI.tfidf <- dfm_tfidf(LI.dfm)
LI2 <- LI.tfidf |>
  convert(to = "data.frame")

# Keyword comparisson
corpus.all <- corpus(presidentes, text_field = 'text', docid_field = 'status_id')

tokens.all <- tokens(corpus.all, remove_punct = TRUE,
                     verbose = TRUE) |> 
  tokens_group(groups = screen_name)
dfm.all <- dfm(tokens.all,
               verbose = TRUE) |> 
  dfm_remove(stopwords("portuguese"),
             verbose = TRUE)

textstat_keyness(dfm.all, target = "LulaOficial") |> 
  textplot_keyness(n= 25)


# Some trigrams
tri.grams<-textstat_collocations(
  LI.tok,
  method = "lambda",
  size = 3,
  min_count = 5,
  smoothing = 0.5,
  tolower = TRUE)






















