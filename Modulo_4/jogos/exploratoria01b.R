writeLines("It is part of my CNPq-funded project and seeks to make corpus tools and R accessible. If you have any doubts or wish to make any research contact please send me an email. Rodrigo de Lima-Lopes rll307@unicamp.br")

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


