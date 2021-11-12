######Introdução##########
#Project: Exploração dos programas dos governadores
#Objective: Observar conexões entre os textos e seus tópicos
#By: rll307
#File: Exploratoria 02

###### Packages ########
library(quanteda)
library(quanteda.textmodels)
library(quanteda.textplots)
library(quanteda.textstats)
library(seededlda)
######## Loading data #########
candidatos.gov <- readRDS("candidatos_unificado.RDS")

####### Some formatting ##########
## Selecting: some data and meta data

candidatos.selec <- 
  candidatos.gov[,c("ANO_ELEICAO", "SG_UF","SG_PARTIDO" , 
                    "DS_SITUACAO_CANDIDATURA",
                    "texto_disponivel", "texto",
                    "TP_AGREMIACAO")] |> as.data.frame()

# Associating candidates' state and party in a ID
candidatos.selec$doc_id <- paste(candidatos.selec$SG_UF , candidatos.selec$SG_PARTIDO, sep = ".")

candidatos.selec$doc_id <- paste(candidatos.selec$doc_id , candidatos.selec$ANO_ELEICAO, sep = ".")

# Making them unique
candidatos.selec$doc_id  <- make.unique(as.character(candidatos.selec$doc_id), sep = ".")
candidatos.selec$cand_ID <- candidatos.selec$doc_id

# Ordering per state
candidatos.selec <- candidatos.selec[order(candidatos.selec$SG_UF),]

# Making availability logical
candidatos.selec$texto_disponivel <- gsub("Sim", 'TRUE', candidatos.selec$texto_disponivel)
candidatos.selec$texto_disponivel <- gsub("Não", 'FALSE', candidatos.selec$texto_disponivel)
candidatos.selec$texto_disponivel <- gsub("Arquivo não existe", 'FALSE', candidatos.selec$texto_disponivel)
candidatos.selec$texto_disponivel <- as.logical(candidatos.selec$texto_disponivel)

#selecting

candidados.f <- subset(candidatos.selec, texto_disponivel == TRUE)

########## Creating the corpus ##########
candidatos.c <- corpus(candidados.f ,
                       text_field = "texto")

tokens.cand <- tokens(candidatos.c, 
                            what = "word",
                            remove_punct = TRUE,
                            remove_symbols = TRUE,
                            remove_numbers = TRUE,
                            remove_url = TRUE, split_hyphens = FALSE, 
                            include_docvars = TRUE, 
                            padding = FALSE, 
                            verbose = TRUE )
dfm.cand <- dfm(tokens.cand, 
                remove = stopwords("portuguese"), 
                verbose = TRUE)

###### Realizando análises ##########
###### Diversidade Lexical
###### Escolhendo alguns partidos 
PT <- corpus_subset(candidatos.c, SG_PARTIDO == "PT")
tokens.PT <- tokens(PT, 
                      what = "word",
                      remove_punct = TRUE,
                      remove_symbols = TRUE,
                      remove_numbers = TRUE,
                      remove_url = TRUE,
                      split_hyphens = FALSE, 
                      include_docvars = TRUE, 
                      padding = FALSE, 
                      verbose = TRUE )
PT.DFM <- dfm(tokens.PT, 
              remove = stopwords("portuguese"), 
              verbose = TRUE)


densidade.PT <- textstat_lexdiv(PT.DFM)
View(densidade.PT)

##### plotando
library(ggplot2)
ggplot(data = densidade.PT, aes(x = document, y = TTR, group = 1)) +
  geom_line() +
  geom_point() +
  theme(axis.text.x = element_text(angle = 60,hjust = 1))

# Similaridade entre documentos
dist <- as.dist(textstat_dist(PT.DFM))
clust <- hclust(dist)
plot(clust, xlab = "Distance", ylab = NULL)


# expressões mais comuns 
col.pt <- textstat_collocations(tokens.PT, min_count = 10, tolower = FALSE)
head(col.pt, 20)

# Modelação de tópicos

PT.DFM.2 <- dfm(tokens.PT) %>% 
  dfm_trim(min_termfreq = 0.8, termfreq_type = "quantile",
           max_docfreq = 0.1, docfreq_type = "prop")
modelo <- textmodel_lda(PT.DFM.2, k = 10)

terms(modelo, 15)
