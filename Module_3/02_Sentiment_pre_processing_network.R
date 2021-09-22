# Introduction ------------------------------------------------------------
# Name: Replication of Lima-Lopes (2020)
# Source for replication: https://revistas2.uepg.br/index.php/muitasvozes/article/view/15506
# Written by Rodrigo de Lima-Lopes at rll307@unicamp.br
# 
writeLines("It is part of my CNPq-funded project and seeks to make corpus tools and R accessible. If you have any doubts or wish to make any research contact please send me an email. Rodrigo de Lima-Lopes rll307@unicamp.br")

# Packages ----------------------------------------------------------------
library(quanteda)
library(quanteda.textplots)
library(quanteda.textstats)

# Building the corpora ----------------------------------------------------
#stopwords
My.Stopwords <- readr::read_csv(file.choose()) 
My.Stopwords  <- My.Stopwords |>
  purrr::as_vector()

# one by one
TS.Corpus <- corpus(TS.df, text_field = 'Content')
DS.Corpus <- corpus(DS.df, text_field = 'Content')
TT.Corpus <- corpus(TT.df, text_field = 'Content')

#General
News.Corpus <- rbind(TT.df,TS.df, DS.df)
News.Corpus <- corpus(News.Corpus, text_field = 'Content')

# Tokens for each and general----------
# 
TS.tokens <- tokens(TS.Corpus,
                    what = "word",
                    remove_punct = TRUE,
                    remove_symbols = TRUE,
                    remove_numbers = TRUE,
                    remove_url = TRUE,
                    split_hyphens = FALSE,
                    include_docvars = TRUE,
                    padding = FALSE,
                    verbose = quanteda_options("verbose")
                    )

TS.tokens <- tokens_remove(TS.tokens, c(stopwords("english"),My.Stopwords)) 
TS.tokens <- tokens_replace(TS.tokens, 
                            pattern = lexicon::hash_lemmas$token,
                            replacement = lexicon::hash_lemmas$lemma) |>
  tokens_tolower()
TS.dfm <- dfm(TS.tokens)
TS.top <- names(topfeatures(TS.dfm, 150))

DS.tokens <- tokens(DS.Corpus,
                    what = "word",
                    remove_punct = TRUE,
                    remove_symbols = TRUE,
                    remove_numbers = TRUE,
                    remove_url = TRUE,
                    split_hyphens = FALSE,
                    include_docvars = TRUE,
                    padding = FALSE,
                    verbose = quanteda_options("verbose")
                    )

DS.tokens <- tokens_remove(DS.tokens, c(stopwords("english"), 
                                        My.Stopwords)) 
DS.tokens <- tokens_replace(DS.tokens, 
                            pattern = lexicon::hash_lemmas$token,
                            replacement = lexicon::hash_lemmas$lemma) |>
  tokens_tolower()

DS.dfm <- dfm(DS.tokens)
DS.top <- names(topfeatures(DS.dfm, 150))

TT.tokens <- tokens(TT.Corpus,
                    what = "word",
                    remove_punct = TRUE,
                    remove_symbols = TRUE,
                    remove_numbers = TRUE,
                    remove_url = TRUE,
                    split_hyphens = FALSE,
                    include_docvars = TRUE,
                    padding = FALSE,
                    verbose = quanteda_options("verbose")
                    ) 
TT.tokens <- tokens_remove(TT.tokens, c(stopwords("english"),My.Stopwords)) 
TT.tokens <- tokens_replace(TT.tokens, 
                            pattern = lexicon::hash_lemmas$token,
                            replacement = lexicon::hash_lemmas$lemma) |>
  tokens_tolower()
TT.dfm <- dfm(DS.tokens)
TT.top <- names(topfeatures(DS.dfm, 150))


News.tokens <- News.Corpus |>
  tokens(what = "word",
         remove_punct = TRUE,
         remove_symbols = TRUE,
         remove_numbers = TRUE,
         remove_url = TRUE,
         split_hyphens = FALSE,
         include_docvars = TRUE,
         padding = FALSE,
         verbose = quanteda_options("verbose")
  )

News.tokens <- tokens_remove(News.tokens, c(stopwords("english"),My.Stopwords)) 
News.tokens <- tokens_replace(News.tokens, 
                            pattern = lexicon::hash_lemmas$token,
                            replacement = lexicon::hash_lemmas$lemma) |>
  tokens_tolower()
news.dfm <- dfm(News.tokens)
news.top <- names(topfeatures(news.dfm, 150))

# FCMs --------------------------------------------------------------------
TS.fcm <- fcm(
  TS.tokens,
  context = 'window',
  count = "frequency",
  window = 2L,
  weights = NULL,
  ordered = FALSE,
  tri = TRUE
)
TS.fcm.top <- fcm_select(TS.fcm , pattern = TS.top)

DS.fcm <- fcm(
  DS.tokens,
  context = 'window',
  count = "frequency",
  window = 2L,
  weights = NULL,
  ordered = FALSE,
  tri = TRUE
)

DS.fcm.top <- fcm_select(DS.fcm , pattern = DS.top)

TT.fcm <- fcm(
  TT.tokens,
  context = 'window',
  count = "frequency",
  window = 2L,
  weights = NULL,
  ordered = FALSE,
  tri = TRUE
)

TT.fcm.top <- fcm_select(TT.fcm , pattern = TT.top)

News.fcm <- fcm(
  News.tokens,
  context = 'window',
  count = "frequency",
  window = 2L,
  weights = NULL,
  ordered = FALSE,
  tri = TRUE
)

News.fcm.top <- fcm_select(News.fcm , pattern = news.top)

# Exporting for external network analysis ---------------------------------

# Now as a matrix
TS.CC <- as.matrix(TS.fcm.top)
DS.CC <- as.matrix(DS.fcm.top)
TT.CC <- as.matrix(TT.fcm.top)
News.CC <- as.matrix(News.fcm.top)

write.csv(TS.CC,"TS.csv")
write.csv(DS.CC,"DS.csv")
write.csv(TT.CC,"TT.csv")
write.csv(News.CC,"News.csv")


# Network with R ----------------------------------------------------------

textplot_network(News.fcm.top, min_freq = 4, edge_color = "orange", edge_alpha = 0.8, edge_size = 5)

textplot_network(TS.fcm.top, min_freq = 4, edge_color = "green", edge_alpha = 0.8, edge_size = 5)

textplot_network(DS.fcm.top, min_freq = 3, edge_color = "darkblue", edge_alpha = 0.8, edge_size = 5)

textplot_network(TT.fcm.top, min_freq = 3, edge_color = "red", edge_alpha = 0.8, edge_size = 3)






























