# Packages ----------------------------------------------------------------
library(quanteda)
library(quanteda.textstats)


# Corpus ------------------------------------------------------------------
corpus.games <- corpus(games.df, text = 'Content', 
                       docid_field = "doc_id")
# kwic --------------------------------------------------------------------
kwic(corpus.games, pattern = "aaa", 
     valuetype = "regex", window = 15) |> 
  View()


