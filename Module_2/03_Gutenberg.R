# Rodrigo Esteves de Lima Lopes \
# *Campinas State University* \
# [rll307@unicamp.br](mailto:rll307@unicamp.br)

# Project Gutenberg Analysis

#' 
#' # Preliminar notes
#' 
#' This is notebook is based on the book:
#' 
#' > Silge, Julia, and David Robinson. 2017. *Text Mining with R: A Tidy Approach*. First edition. Beijing/Boston: O’Reilly.
#' 
#' # Comparing books
#' In this tutorial we will use some books by of *Machado de Assis* available at [Projeto Gutemberg](https://www.gutenberg.org/) in order to create a comparison between the different lexical choices present in each book.
#' 
#' ## Loading packages
#' To carry out this tutorial, we need to load some packages:
#' 
## ----packages---------------------------------------------------
library(dplyr)
library(tidytext)
library(ggplot2)
library(gutenbergr)

#' 
#' 1. `library (dplyr)` is for data manipulation
#' 1. `library (tidytext)`  is for text manipulation
#' 1. `library (ggplot2)` is for plotting 
#' 1. `library (gutenbergr)` downloads data from [Project Gutemberg](https://www.gutenberg.org/)
#' 
#' For some reason,project gutemberg is not going to following commands will scrape the books and convert the characters to a compatible encoding
#' 
## ----scraping---------------------------------------------------
#Memórias Póstumas (MP)
MP.bruto <- gutenberg_download(54829)%>%
  mutate(text=iconv(text, from = "latin1", to = "UTF-8"))
MP.bruto$title<-"MP"

#Dom Casmurro (DM)
DC.bruto <- gutenberg_download(55752)%>%
  mutate(text=iconv(text, from = "latin1", to = "UTF-8"))
DC.bruto$title<-"DC"

#Memorial de Ayres (MA)
MA.bruto <- gutenberg_download(55797)%>%
  mutate(text=iconv(text, from = "latin1", to = "UTF-8"))
MA.bruto$title<-"MA"

#' 
#' ## Organising the data
#' 
#' First of all we will join ou books in a single data frame:
#' 
## ----single_dataframe-------------------------------------------
machado.bruto <- rbind(MP.bruto,DC.bruto,MA.bruto)

#' 
#' The following commands will organise the lexis in the file based on some criteria:
#' -  `unnest_tokens (word, text)`  splits one word per line, from the column **text** that contains the lines of the novels
#' - `count (title, word, sort = TRUE)` counts the words in each novel;
#' - `ungroup ()` breaks  words by line. 
#' 
## ----words_per_title--------------------------------------------
machado.p.1 <- machado.bruto %>%
  unnest_tokens(word, text) %>%
  count(title, word, sort = TRUE) %>%
  ungroup()

#' 
#' Now let us see the total words per title:
#' 
## ----total_words_per_title--------------------------------------
machado.total <- machado.p.1 %>%
  group_by(title) %>%
  summarize(total = sum(n))

#' 
#' Now, we are going to add the number of words to the general table.
#' 
## ----palavras01-------------------------------------------------
machado.palavras <- left_join(machado.p.1, machado.total)

#' 
#' ## Plotting
#' 
#' Now let us do some plotting. The package `ggplot2` will give us a hand
#' 
## ----plot01-----------------------------------------------------
ggplot(machado.palavras, aes(n/total, fill = title)) +
  geom_histogram(show.legend = FALSE) +
  xlim(NA, 0.0009) +
  facet_wrap(~title, ncol = 2, scales = "free_y")

#' 
#' ## Raking our lexis
#' 
#' The plots above compare the words in their absolute numbers. It would be interesting for us to establish a ranking amongst those words. This would help us to separate purely grammatical words from those that can bring some reflection on the content. Let us do it step by step. 
#' 
## ----rank-------------------------------------------------------
machado.palavras.rank <- machado.palavras %>%
  group_by(title) %>%
  mutate(rank = row_number(),
         `term frequency` = n/total)

#' 
#' Now let us plot and see the difference
#' 
## ----plot2------------------------------------------------------
machado.palavras.rank  %>%
  ggplot(aes(rank, `term frequency`, color = title)) +
  geom_line(size = 1.1, alpha = 0.8, show.legend = TRUE) +
  scale_x_log10() +
  scale_y_log10()

#' 
#' Now let's calculate the regression of those words. This will help us to know whether, within the repetitions we see, such averages are expected or not.
#' 
## ----regression-------------------------------------------------
rank_subset <- machado.palavras.rank %>%
  filter(rank < 500,
         rank > 10)

lm(log10(`term frequency`) ~ log10(rank), data = rank_subset)

#' 
#' Now let us see how it fits our old plotting
#' 
## ---------------------------------------------------------------
machado.palavras.rank %>%
  ggplot(aes(rank, `term frequency`, color = title)) +
  geom_abline(intercept = -0.966, slope = -1.0004, color = "black", linetype = 1) +
  geom_line(size = 1.1, alpha = 0.9, show.legend = TRUE) +
  scale_x_log10() +
  scale_y_log10()

#' 
#' 
#' The black line gives us the normality. We observe that few words are above or below it, with variations in each work.
#' 
#' That done, let us calculate the importance that each of these words have in our texts, and then use it.
#' 
## ----final_calcularion------------------------------------------
machado.palavras.imp  <- machado.palavras  %>%
  bind_tf_idf(word, title, n)

#' 
## ----final_plot-------------------------------------------------
machado.palavras.imp  %>%
  arrange(desc(tf_idf)) %>%
  mutate(word = factor(word, levels = rev(unique(word)))) %>%
  group_by(title) %>%
  top_n(15) %>%
  ungroup() %>%
  ggplot(aes(word, tf_idf, fill = title)) +
  geom_col(show.legend = FALSE) +
  labs(x = NULL, y = "tf-idf") +
  facet_wrap(~title, ncol = 2, scales = "free") +
  coord_flip()

#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
