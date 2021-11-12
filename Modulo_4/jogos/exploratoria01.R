# Introducao --------------------------------------------------------------
#Project: Blogs de resenha game
#Objective: Análise exploratória 01
#By: rll307
#Date: 10/Nov/2021 (Wed)

# TODOS -------------------------------------------------------------------

load("modulo3.RData")
rm(test,file.name,articles_AR,articles_GG,articles_GV,i, my.files,location,ARD.df, GGD.df,GVD.df)

# Pacotes -----------------------------------------------------------------
library(tidytext)
library(dplyr)
library(tidyverse)
library(tidyr)

# Pré-processamento -------------------------------------------------------
# Criando lista de palavras AR

AR.list  <- data.frame(text = AR.df$Content, 
                   stringsAsFactors = F) %>%
  unnest_tokens(word, text) %>%
  mutate(blog = "AR")

# Lista de palavras 
# ARD
GG.list <- data.frame(text = GG.df$Content,
                   stringsAsFactors = F) %>%
  unnest_tokens(word, text) %>%
mutate(blog = "GG")

# Lista de palavras 
# GV
GV.list <- data.frame(text = GV.df$Content,
                   stringsAsFactors = F) %>%
  unnest_tokens(word, text) %>%
mutate(blog = "GV")

freq.games <- bind_rows(mutate(GV.list, blog = "GV"),
                        mutate(GG.list, blog = "GG"),
                        mutate(AR.list, blog = "AR"))  |>
  mutate(word = str_extract(word, "[a-z']+"))  |>
  count(blog, word)  |>
  group_by(blog)  |>
  mutate(proportion = (n / sum(n))*100)  |>
  select(-n)  |>
  spread(blog, proportion)
freq.games <- freq.games[-(1:2),]

# Juntando e observando a mais importante
games.df <- rbind(GG.df,GV.df,AR.df) 

games.df$site <- as.factor(games.df$site)

games.wl  <- games.df |>
  unnest_tokens(word, Content)
games.wl <- games.wl[,2:4]

freq.sites.tf_idf <- games.wl  |>
  count(site, word) |>
  bind_tf_idf(word, site, n) |>
  arrange(desc(tf_idf))

# Agora, por documento
freq.docs.tf_idf <- games.wl  |>
  count(doc_id, word) |>
  bind_tf_idf(word, doc_id, n) |>
  arrange(desc(tf_idf))

# Analisando bigramas -----------------------------------------------------

MsW <- stopwords::stopwords("pt") |> 
  as.data.frame()
colnames(MsW) <- "word"

games.bigrams <- games.df |>
  unnest_tokens(bigram, Content, token = "ngrams", n = 2) 
games.bigrams <- games.bigrams[,2:4]

games.b.count <- games.bigrams  |>
  count(bigram, sort = TRUE)

games.separados <- games.bigrams |>
  separate(bigram, c("word1", "word2"), sep = " ")

games.filtered <- games.separados |>
  filter(!word1 %in% MsW$word) |>
  filter(!word2 %in% MsW$word)

games.b.count <- games.filtered |> 
  count(word1, word2, sort = TRUE)

games.juntos <- games.filtered |>
  unite(bigram, word1, word2, sep = ' ')

# Realizando so graficos----------

GG.count <- games.juntos |>
  subset(site == "Garotas Geeks") |>
  count(bigram, sort = TRUE) |>
  separate(bigram, c("word1", "word2"), sep = " ")

AR.count <- games.juntos |>
  subset(site == "Arkade") |>
  count(bigram, sort = TRUE) |>
  separate(bigram, c("word1", "word2"), sep = " ")

GV.count <- games.juntos |>
  subset(site == "Gamer View") |>
  count(bigram, sort = TRUE) |>
  separate(bigram, c("word1", "word2"), sep = " ")

GG.graph <- GG.count |>
  filter(n > 5) |>
  igraph::graph_from_data_frame()

GV.graph <- GV.count |>
  filter(n > 5) |>
  igraph::graph_from_data_frame()

AR.graph <- AR.count |>
  filter(n > 5) |>
  igraph::graph_from_data_frame()

ggraph::ggraph(GG.graph, layout = "fr") +
  ggraph::geom_edge_link() +
  ggraph::geom_node_point() +
  ggraph::geom_node_text(aes(label = name), 
                         vjust = 1, hjust = 1)

ggraph::ggraph(GV.graph, layout = "fr") +
  ggraph::geom_edge_link() +
  ggraph::geom_node_point() +
  ggraph::geom_node_text(aes(label = name), 
                         vjust = 1, hjust = 1)

ggraph::ggraph(AR.graph, layout = "fr") +
  ggraph::geom_edge_link() +
  ggraph::geom_node_point() +
  ggraph::geom_node_text(aes(label = name), 
                         vjust = 1, hjust = 1)




































