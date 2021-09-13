
# Packages ----------
library(tidytext) #OK
library(dplyr) #OK
library(tidyverse)
library(tidyr)
library(stringr)
# library(ggraph) Only one function in the code
# library(textreadr) only one function in the code
# library(abjutils) only one command inside functions
# library(textclean) only one command inside functions
# library(readr) only one function in the code
#library(scales) Only one function in the code
#library(ggplot2) Only one function in the code


## Loading functions----------
source("05_TidyText_functions.R")

## Reading data ----------
### Stopwords

My.Stopwords <- data.frame(
  readr::read_csv("stop_port2.csv", col_names = FALSE),stringsAsFactors = FALSE
  )

colnames(My.Stopwords) <- "word"

### Novels
estrela <- textreadr::read_document("estrela.txt")
paixao <- textreadr::read_document("paixao.txt")

# creating data frames
estrela <- data.frame(text = estrela, stringsAsFactors = F)
paixao <- data.frame(text = paixao, stringsAsFactors = F)

## Cleaning the text----------

analise.paixao <- Clean_String(paixao$text) |>
  data.frame()
colnames(analise.paixao) <- 'text'

analise.estrela <- Clean_String(estrela$text) |>
  data.frame()
colnames(analise.estrela) <- 'text'

## creating tidy files----------
paixao.tidy <- analise.paixao  |>
  unnest_tokens(word, text) |>
  anti_join(My.Stopwords, by = "word")
paixao.l <- paixao.tidy |>
  count(word, sort = TRUE)

estrela.tidy <- analise.estrela |>
  unnest_tokens(word, text) |>
  anti_join(My.Stopwords, by = "word")
esterla.l <- estrela.tidy |>
  count(word, sort = TRUE)

# Frequency table
frequencia.clarisse <- bind_rows(mutate(paixao.tidy, livro = "P"),
                                 mutate(estrela.tidy, livro = "H"))  |>
  mutate(word = str_extract(word, "[a-z']+"))  |>
  count(livro, word)  |>
  group_by(livro)  |>
  mutate(proportion = (n / sum(n))*100)  |>
  select(-n)  |>
  spread(livro, proportion)

# Impoving my stopword list

My.Stopwords <- data.frame(word = c(My.Stopwords$word,"aaaar"))

# Now run again...

## Visualising comparison ----------
## 
ggplot(frequencia.clarisse, aes(x = H, y = P,
                                color = abs(H - P))) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) + 
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) + 
  scale_x_log10(labels = scales::percent_format()) +
  scale_y_log10(labels = scales::percent_format()) + 
  scale_color_gradient(limits = c(0, 0.001),
                       low = "darkslategray4", high = "gray75") +
  theme(legend.position = "none") + 
  labs(y = "Paixão segundo GH", x = "Hora da Estrela")

### Doing bigrams --------

# Adding a column with book titles 
analise.estrela$book <- "Hora da Estrela"
analise.paixao$book <- "Paixao segundo GH"
# Joining
clarisse.livros <- rbind(analise.estrela,analise.paixao)
clarisse.livros$book <- as.factor(clarisse.livros$book)

# Creating bigrams
clarisse.bigrams <- clarisse.livros |>
  unnest_tokens(bigram, text, token = "ngrams", n = 2)

# Counting total
bigrams.count <- clarisse.bigrams |>
  count(bigram, sort = TRUE)

# Counting each book
hora.count <- clarisse.bigrams |>
  subset(book == "Hora da Estrela") |>
  count(bigram, sort = TRUE) |>
  separate(bigram, c("word1", "word2"), sep = " ")

hora.count <- hora.count[-3,]

paixao.count <- clarisse.bigrams |>
  subset(book == "Paixao segundo GH") |>
  count(bigram, sort = TRUE) |>
  separate(bigram, c("word1", "word2"), sep = " ")

paixao.count <- paixao.count[-3,]

# Separating
clarisse.separated <- clarisse.bigrams |>
  separate(bigram, c("word1", "word2"), sep = " ")

# now cleaning the stopwords

clarisse.filtered <- clarisse.separated |>
  filter(!word1 %in% My.Stopwords$word) |>
  filter(!word2 %in% My.Stopwords$word)

# Counting the filtered bigrams

bigrams.count <- clarisse.filtered |> 
  count(word1, word2, sort = TRUE)

# Merging the bigrams

clarisse.united <- clarisse.filtered |>
  unite(bigram, word1, word2, sep = " ")

### Doing some analysis----------

# creating relative frequency 
clarisse.tf_idf <- clarisse.united |>
  count(book, bigram) |>
  bind_tf_idf(bigram, book, n) |>
  arrange(desc(tf_idf))

## Ploting the relative frequency

clarisse.tf_idf  |>
  arrange(desc(tf_idf)) |>
  mutate(bigram = factor(bigram, levels = rev(unique(bigram)))) |>
  group_by(book) |>
  top_n(10) |>
  ungroup() |>
  ggplot2::ggplot(aes(bigram, tf_idf, fill = book)) +
  geom_col(show.legend = FALSE) +
  labs(x = NULL, y = "tf-idf") +
  facet_wrap(~book, ncol = 2, scales = "free") +
  coord_flip()

# plotting a network graphic
# Only more than 20
hora.graph <- hora.count |>
  filter(n > 10) |>
  igraph::graph_from_data_frame()

set.seed(1973)

ggraph::ggraph(hora.graph, layout = "fr") +
  ggraph::geom_edge_link() +
  ggraph::geom_node_point() +
  ggraph::geom_node_text(aes(label = name), vjust = 1, hjust = 1)


paixao.graph <- paixao.count |>
  filter(n > 20) |>
  igraph::graph_from_data_frame()

ggraph::ggraph(paixao.graph, layout = "fr") +
  ggraph::geom_edge_link() +
  ggraph::geom_node_point() +
  ggraph::geom_node_text(aes(label = name), vjust = 1, hjust = 1)

# Now doing all together
# Filtered
set.seed(1973)
clarisse.g <- clarisse.filtered[,2:3] |>
  count(word1, word2, sort = TRUE)
clarisse.g <- clarisse.g[-1,]
general.graph <- clarisse.g |>
  filter(n > 4) |>
  igraph::graph_from_data_frame()

ggraph::ggraph(general.graph, layout = "fr") +
  ggraph::geom_edge_link() +
  ggraph::geom_node_point() +
  ggraph::geom_node_text(aes(label = name), vjust = 1, hjust = 1)













