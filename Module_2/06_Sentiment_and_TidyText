# Initial info ------------------------------------------------------------
# Name: Harry Potter replication
# Source: https://uc-r.github.io/sentiment_analysis
# Written by Rodrigo de Lima-Lopes at rll307@unicamp.br

writeLines("It is part of my CNPq-funded project and seeks to make corpus tools and R accessible. If you have any doubts or wish to make any research contact please send me an email. Rodrigo de Lima-Lopes rll307@unicamp.br")

# Packages and data ----------------------------------------------------------------
# Installing Packages 
# We are installing an unofficial package so we have to install devtools first
if (packageVersion("devtools") < 1.6) {
  install.packages("devtools")
}
# Them to install directly from Github
devtools::install_github("bradleyboehmke/harrypotter")

# Loading Packages 
# If you do not have one of these, please install them using common 
library(tidyverse)      # Data manipulation
library(stringr)        # Regular expressions and text cleaning
library(tidytext)       # Text mining 
library(harrypotter)    # Our data

# Get sentiments using TidyText
get_sentiments("afinn")
get_sentiments("bing")
get_sentiments("nrc")


# A basic analysis ---------------------------------------------------
# Selecting data
# Creating a data frame with titles
titles <- c("Philosopher's Stone", "Chamber of Secrets", "Prisoner of Azkaban",
            "Goblet of Fire", "Order of the Phoenix", "Half-Blood Prince",
            "Deathly Hallows")
# Creating a data frame with
books <- list(philosophers_stone, chamber_of_secrets, prisoner_of_azkaban,
              goblet_of_fire, order_of_the_phoenix, half_blood_prince,
              deathly_hallows)
# Creating an empty data frame for latter use
WL.Books <- tibble()

# Making a comprehensive wordlist
for (i in seq_along(titles)) {
  pre.list <- tibble(chapter = seq_along(books[[i]]),
                     text = books[[i]]) %>%
    unnest_tokens(word, text) %>%
    mutate(book = titles[i]) %>%
    select(book, everything())
  WL.Books <- rbind(WL.Books, pre.list)
}

# Now we will make the books as factors, for classification and ordering
WL.Books$book <- factor(WL.Books$book, levels = titles)

# Let us have a close look in one of the data frames for sentiment
sent.nrc <- get_sentiments("nrc")

Sentiment.Books <- WL.Books |>
  right_join(get_sentiments("nrc")) |>
  filter(!is.na(sentiment)) |>
  count(sentiment, sort = TRUE)

ggplot2::ggplot(Sentiment.Books, aes(x = sentiment, y = n)) + 
  geom_bar(stat = "identity")


# A first comparison ----------------------------------------------------
#Counting words and creating a an index
Word.Index <- WL.Books |>
  # Group words by book
  group_by(book) |>
  # Creates an index of 1000 words for the comparison to bee equal
  mutate(word_count = 1:n(),
         index = word_count %/% 500 + 1) 

# joining with sentiments
Word.Index <- Word.Index |>
  # Joining by the words in common in bing
  inner_join(get_sentiments("bing")) 

#Counting sentiments and books
Word.Index <- Word.Index |>
  count(book, index = index , sentiment) |>
  ungroup() 
# Spreading the sentiments
Word.Index <- Word.Index |>
  spread(sentiment, n)

# Determinating the final sentiment
Word.Index <- Word.Index |>
  mutate(sentiment = positive - negative,
         book = factor(book, levels = titles))

# Now in a single command (preferable and more elegant)
Word.Index <- WL.Books |>
  group_by(book) |>
  mutate(word_count = 1:n(),
         index = word_count %/% 500 + 1) |>
  inner_join(get_sentiments("bing")) |>
  count(book, index = index , sentiment) |>
  ungroup() |>
  spread(sentiment, n) |>
  mutate(sentiment = positive - negative,
         book = factor(book, levels = titles))

# Now plotting
Word.Index |> 
  ggplot2::ggplot(aes(index, sentiment, fill = book)) +
  geom_bar(alpha = 0.5, stat = "identity", show.legend = FALSE) +
  facet_wrap(~ book, ncol = 2, scales = "free_x")

# Comparing three sentiment packages --------------------------------------


WI.afinn <- WL.Books |>
  group_by(book) |>
  mutate(word_count = 1:n(),
         index = word_count %/% 500 + 1) |>
  inner_join(get_sentiments("afinn")) |>
  group_by(book, index) |>
  summarise(sentiment = sum(value)) |>
  mutate(method = "AFINN")

WI.bing <- bind_rows(WL.Books |>
                       group_by(book) |>
                       mutate(word_count = 1:n(),
                              index = word_count %/% 500 + 1) |> 
                       inner_join(get_sentiments("bing")) |>
                       mutate(method = "Bing") |> 
                       count(book, method, index = index , sentiment) |>
                       ungroup() |>
                       spread(sentiment, n, fill = 0) |> 
                       mutate(sentiment = positive - negative) |>
                       select(book, index, method, sentiment)
                     )
                     
WI.NRC <- bind_rows(WL.Books |>
                      group_by(book) |>
                      mutate(word_count = 1:n(),
                             index = word_count %/% 500 + 1) |>
                      inner_join(get_sentiments("nrc") |>
                                   filter(sentiment %in% c("positive", "negative"))) |>
                      mutate(method = "NRC") |> 
                      count(book, method, index = index , sentiment) |>
                      ungroup() |>
                      spread(sentiment, n, fill = 0) |>
                      mutate(sentiment = positive - negative) |>
                      select(book, index, method, sentiment)
                    )

final.sentiments <- bind_rows(WI.afinn, WI.bing,WI.NRC) |>
  ungroup() |>
  mutate(book = factor(book, levels = titles))

final.sentiments |> 
  ggplot2::ggplot(aes(index, sentiment, fill = method)) +
  geom_bar(alpha = 0.8, stat = "identity", show.legend = FALSE) +
  facet_grid(book ~ method)


# Approaching sentences ---------------------------------------------------
#Viewing the organisation of the book:

philosophers_stone |> 
  tibble() |> 
  View()

#Organising by sentences and chapters
PS.sentences <- tibble(chapter = 1:length(philosophers_stone),
                       text = philosophers_stone) |> 
  unnest_tokens(sentence, text, token = "sentences")

PS.sentiments <- PS.sentences %>%
  #grouping by chapter 
  group_by(chapter) %>%
  #Creating the index
  mutate(sentence_num = 1:n(),
         index = round(sentence_num / n(), 2)) %>%
  #grouping by chapter and index
  group_by(chapter,index) %>%
  # Splitting the words and sentences
  unnest_tokens(word, sentence) %>%
  inner_join(get_sentiments("afinn")) %>%
  #Summarising the values
  summarise(sentiment = sum(value, na.rm = TRUE)) %>%
  #Organising
  arrange(desc(sentiment))

ggplot2::ggplot(PS.sentiments, aes(index, factor(chapter, levels = sort(unique(chapter), decreasing = TRUE)), fill = sentiment)) +
  geom_tile(color = "white") +
  scale_fill_gradient2() +
  scale_x_continuous(labels = scales::percent, expand = c(0, 0)) +
  scale_y_discrete(expand = c(0, 0)) +
  labs(x = "Chapter Progression", y = "Chapter") +
  ggtitle("Sentiment of Harry Potter and the Philosopher's Stone",
          subtitle = "Summary of the  sentiment score as it progresses through the chapters") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = "top")










