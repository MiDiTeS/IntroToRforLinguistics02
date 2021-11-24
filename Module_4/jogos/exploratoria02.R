writeLines("It is part of my CNPq-funded project and seeks to make corpus tools and R accessible. If you have any doubts or wish to make any research contact please send me an email. Rodrigo de Lima-Lopes rll307@unicamp.br")

# Introducao --------------------------------------------------------------
#Project: Blogs de resenha game
#Objective: Análise exploratória 02
#By: rll307
#Date: 11/Nov/2021 (Thu)

# Packages ----------------------------------------------------------------
library(udpipe)
library(ggplot2)
library(data.table)
library(word2vec)
library(psych)
library(quanteda)
library(dplyr)
library(uwot)
library(ggrepel)
# Carregando o modelo -----------------------------------------------------
udmodel <- udpipe_download_model(language = "portuguese")
udmodel <- udpipe_load_model(file = 'portuguese-bosque-ud-2.5-191206.udpipe')

# Etiquetando

GG.tag <- udpipe_annotate(object = udmodel,  
                          x = GG.df$Content, 
                          doc_id = GG.df$doc_id) |>
  as.data.frame()


GV.tag <- udpipe_annotate(object = udmodel,  
                          x = GV.df$Content, 
                          doc_id = GV.df$doc_id) %>%
  as.data.frame()

AR.tag <- udpipe_annotate(object = udmodel,  
                          x = AR.df$Content, 
                          doc_id = AR.df$doc_id) %>%
  as.data.frame()


# Analise preliminar (etiquetas) ------------------------------------------
# AR
AR.stats <- txt_freq(AR.tag$upos)

AR.stats$key <- factor(AR.stats$key, levels = rev(AR.stats$key))
ggplot(AR.stats, aes(y = freq_pct, x=key,)) + 
  geom_bar(stat = "identity") +
  scale_y_continuous("Frequência") + 
  theme(axis.text.x = element_text(angle = 60,hjust = 1)) 

# GG
GG.stats <- txt_freq(GG.tag$upos)
GG.stats$key <- factor(GG.stats$key, levels = rev(GG.stats$key))
ggplot(GG.stats, aes(y = freq_pct, x=key,)) + 
  geom_bar(stat = "identity") +
  scale_y_continuous("Frequência") + 
  theme(axis.text.x = element_text(angle = 60,hjust = 1)) 

# GV
GV.stats <- txt_freq(GV.tag$upos)
GV.stats$key <- factor(GV.stats$key, levels = rev(GV.stats$key))
ggplot(GV.stats, aes(y = freq_pct, x=key,)) + 
  geom_bar(stat = "identity") +
  scale_y_continuous("Frequência") + 
  theme(axis.text.x = element_text(angle = 60,hjust = 1)) 

# Separnado os verbos
AR.verbos <- subset(AR.tag, upos == "VERB")

AR.stats <- txt_freq(AR.verbos$lemma)

AR.stats$key <- factor(AR.stats$key, levels = rev(AR.stats$key))

AR.Verb.plot <- AR.stats[1:20,]

ggplot(AR.Verb.plot, aes(y = freq_pct, x=key,)) + 
  geom_bar(stat = "identity") +
  scale_y_continuous("Frequência") + 
  theme(axis.text.x = element_text(angle = 60,hjust = 1)) 

GG.verbos <- subset(GG.tag, upos == "VERB")
GG.stats <- txt_freq(GG.verbos$lemma)
GG.stats$key <- factor(GG.stats$key, levels = rev(GG.stats$key))
GG.Verb.plot <- GG.stats[1:20,]
ggplot(GG.Verb.plot, aes(y = freq_pct, x=key,)) + 
  geom_bar(stat = "identity") +
  scale_y_continuous("Frequência") + 
  theme(axis.text.x = element_text(angle = 60,hjust = 1)) 

GV.verbos <- subset(GV.tag, upos == "VERB")
GV.stats <- txt_freq(GV.verbos$lemma)
GV.stats$key <- factor(GV.stats$key, levels = rev(GV.stats$key))
GV.Verb.plot <- GV.stats[1:20,]
ggplot(GV.Verb.plot, aes(y = freq_pct, x=key,)) + 
  geom_bar(stat = "identity") +
  scale_y_continuous("Frequência") + 
  theme(axis.text.x = element_text(angle = 60,hjust = 1)) 

# Co-ocorrencias ----------------------------------------------------------

# Substantivos e adjetivos
AR.Su.Adj <- cooccurrence(x = subset(AR.tag, upos %in% c("NOUN", "ADJ")), 
                     term = "lemma", 
                     group = c("doc_id", "paragraph_id", "sentence_id"))

GG.Su.Adj <- cooccurrence(x = subset(GG.tag, upos %in% c("NOUN", "ADJ")), 
                          term = "lemma", 
                          group = c("doc_id", "paragraph_id", "sentence_id"))

GV.Su.Adj <- cooccurrence(x = subset(GV.tag, upos %in% c("NOUN", "ADJ")), 
                          term = "lemma", 
                          group = c("doc_id", "paragraph_id", "sentence_id"))

# Com significancia estatistica
# 
AR.tag$id <- unique_identifier(AR.tag, fields = c("sentence_id", "doc_id"))

AR.dtm <- subset(AR.tag, upos %in% c("NOUN", "ADJ"))

AR.dtm <- document_term_frequencies(AR.dtm, document = "id", term = "lemma")

AR.dtm <- document_term_matrix(AR.dtm)

AR.dtm <- dtm_remove_lowfreq(AR.dtm, minfreq = 3)

AR.correlations <- dtm_cor(AR.dtm)

AR.cooc <- as_cooccurrence(AR.correlations)

AR.cooc <- subset(AR.cooc, term1 < term2 & abs(cooc) > 0.2)
AR.cooc <- AR.cooc[order(abs(AR.cooc$cooc), decreasing = TRUE), ]

# Colocacoes 02 -----------------------------------------------------------

colloc <- keywords_collocation(GG.tag , term = "lemma", group = c("doc_id", "sentence_id"), ngram_max = 3, n_min = 3)
colloc <- subset(colloc, left == "jogo")

GG.t <- as.data.table(GG.tag)
GG.t[, upos_previous := txt_previous(upos, n = 1), by = list(doc_id, sentence_id)]

GG.t[, upos_next := txt_next(upos, n = 1), by = list(doc_id, sentence_id)]

GG.t <- subset(GG.t, (upos %in% c("VERB") & upos_previous %in% c("NOUN")) | (upos %in% c("NOUN") & upos_next %in% c("VERB")))

colloc <- keywords_collocation(GG.t, term = "lemma", group = c("doc_id", "sentence_id"), ngram_max = 2, n_min = 1)

## Criando um modelo de análise----------

set.seed(2360873)

GG <- tolower(GG.df$Content)

meu.modelo <- word2vec(x = GG, type = "cbow", dim = 15, iter = 25)
embedding <- as.matrix(meu.modelo)

# Observando fraseologias no modelo
embedding <- predict(meu.modelo, c("jogo", "personagem"), type = "embedding")

lookslike <- predict(meu.modelo, c("jogo", "personagem"), type = "nearest", top_n = 15)
lookslike

embedding <- predict(meu.modelo, c("fazer", "ter","poder","jogar"), type = "embedding")
lookslike <- predict(meu.modelo, c("fazer", "ter","poder","jogar"), type = "nearest", top_n = 15)
lookslike

# plotando

AR.tag$id <- NULL
tags.total <- rbind(AR.tag,GG.tag,GV.tag)
plot.base <- filter(tags.total, !is.na(lemma) & !upos %in% c("X","SYM", "PUNCT"))
plot.base$text <- sprintf("%s//%s", plot.base$lemma, plot.base$upos)
plot.base <- paste.data.frame(plot.base, term = "text", group = "doc_id", collapse = " ")
model     <- word2vec(x = plot.base$text, dim = 15, iter = 20, split = c(" ", ".\n?!"))
embedding <- as.matrix(model)
viz <- umap(embedding, n_neighbors = 15, n_threads = 2)
plot.final  <- data.frame(word = gsub("//.+", "", rownames(embedding)), 
                  upos = gsub(".+//", "", rownames(embedding)), 
                  x = viz[, 1], y = viz[, 2], 
                  stringsAsFactors = FALSE)

plot.final  <- subset(plot.final, upos %in% c("ADJ","NOUN"))
ggplot(plot.final, aes(x = x, y = y, label = word, color = upos))+
  geom_text_repel(force = 5, max.overlaps = 13) +
  geom_point()

# Associações e dessassociações 
wv <- predict(meu.modelo, newdata = c("poder", "jogar", "lutadores"), type = "embedding")
wv <- wv["poder", ] - wv["jogar", ] + wv["lutadores", ] 
predict(meu.modelo, newdata = wv, type = "nearest", top_n = 10)








