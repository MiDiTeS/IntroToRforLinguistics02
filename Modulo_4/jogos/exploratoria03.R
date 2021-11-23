# Introducao --------------------------------------------------------------
#Project: Blogs de resenha game
#Objective: Análise exploratória 
#By: rll307
#Date: 22/11/21
#

# Pacotes -----------------------------------------------------------------
library(abjutils)
library(tidytext)
library(tidyverse)
library(stm)
library(tm)
library(ggridges)
library(formattable)
library(dbplyr)
library(ggplot2)
library(ggridges)

# Dados -------------------------------------------------------------------
load("modulo3.RData")
rm(ARD.df,GGD.df,GVD.df, location,test,articles_AR,articles_GG,articles_GV,file.name,i, my.files)
AR.df$Blog <- "AR"
GG.df$Blog <- "GG"
GV.df$Blog <- "GV"
Blogs <- rbind(AR.df,GG.df,GV.df)
metadata.blogs <- Blogs[ ,-2]

sw_pt <- c("este", "estes", "esta", "estas", "isto", "esse", "esses", "essa", "essas", "isso","a", "ante", "até", "após", "com", "contra", "de", "desde", "em", "entre", "para", "per", "perante", "por", "sem", "sob", "sobre", "trás", "abaixo de", "acima de", "a fim de", "além de", "a par de", "apesar de", "atrás de", "através de", "o", "as", "os", "a", "da", "das", "do", "dos", "um", "uns", "uma", "umas", "por", "pelo", "pela", "pelos", "pelas", "aquele", "aqueles", "aquela", "aquelas", "aquilo", "mesmo", "mesma", "tal", "tais","naquele","naquela", 'naquelas',"naqueles", "entre","sem", "depois", "antes","nem","numa","como", "não", "já","no","na","nos","nas",'também',"tudo",'todo',"onde","algo","fazer","aqui","ali","faz","pra","está", "estamos", "estão", "estive", "esteve", "estivemos", "estiveram", "estava", "estávamos", "estavam", "estivera", "estivéramos", "esteja", "estejamos", "estejam", "estivesse", "estivéssemos", "estivessem", "estiver", "estivermos", "estiverem", "hei", "há", "havemos", "hão", "houve", "houvemos", "houveram", "houvera", "houvéramos", "haja", "hajamos", "hajam", "houvesse", "houvéssemos", "houvessem", "houver", "houvermos", "houverem", "houverei", "houverá", "houveremos", "houverão", "houveria", "houveríamos", "houveriam", "sou", "somos", "são", "era", "éramos", "eram", "fui", "foi", "fomos", "foram", "fora", "fôramos", "seja", "sejamos", "sejam", "fosse", "fôssemos", "fossem", "for", "formos", "forem", "serei", "será", "seremos", "serão", "seria", "seríamos", "seriam", "tenho", "tem", "temos", "tém", "tinha", "tínhamos", "tinham", "tive", "teve", "tivemos", "tiveram", "tivera", "tivéramos", "tenha", "tenhamos", "tenham", "tivesse", "tivéssemos", "tivessem", "tiver", "tivermos", "tiverem", "terei", "terá", "teremos", "terão", "teria", "teríamos", "teriam","outro","outros","outra", "toda","todas","sendo","além","ter","contudo","pode","alguma", "algumas", "alguns","algum","entao","ainda","ser", "assim","podem","enquanto","porem","apesar","talvez","outra","outras","pois","durante","porque","gente","dentro","julio","gente","tanto","cada","-mail","desta","destas", "deste", "destes", "qual","quais","vai","tao","tira","vai","tipo","agora","disso","coisa","coisas","ver","qualquer","ate","etc","quanto","atraves","mail","sim")
sw_pt <- rm_accent(sw_pt)

Blogs$Content <- rm_accent(Blogs$Content)

# Processando -------------------------------------------------------------

proc <- 
  stm::textProcessor(Blogs$Content, metadata = metadata.blogs,
                     language = "portuguese",
                     customstopwords = sw_pt,
                     stem = FALSE,
                     verbose = TRUE)
out <- 
  stm::prepDocuments(proc$documents,
                     proc$vocab, 
                     proc$meta,
                     lower.thresh = 3,
                     verbose = TRUE)
storage <-
  stm::searchK(out$documents,
               out$vocab, K = c(3:10),
               data = out$meta)

plot.searchK(storage)

fit <- stm::stm(documents = out$documents,
                vocab = out$vocab, data = out$meta,  K = 4,
                max.em.its = 75, init.type = "LDA",
                verbose = TRUE)

plot.STM(fit, type = "labels",labeltype = "prob")
plot.STM(fit, type = "labels",labeltype = "frex")
plot.STM(fit, type = "labels",labeltype = "lift")
plot.STM(fit, type = "labels",labeltype = "score")
plot.STM(fit, type = "perspectives",topics = c(1,2))
plot.STM(fit, type = "hist")
stm::labelTopics(fit)
View(fit$theta)

#Melhor probabilidade de topicos em cada resenha""
prob <- apply(fit$theta, 1, max)

# Criando um nome para os tópicos

topicos <- c("A","B","C","D")

Videos.Topic <- topicos[apply(fit$theta, 1, which.max)]

df_topicos <- Blogs  |> 
  mutate(best_prob = prob,
         topico = Videos.Topic)


# Plotando ----------------------------------------------------------------


colour <- "bisque4"

df_topicos  |> 
  count(topico) |> 
  mutate(topico = forcats::fct_reorder(topico, n)) |> 
  ggplot(aes(x = topico, y = n)) + 
  geom_col(fill = colour) +
  theme_minimal() + 
  labs(x = "Topicos", y = "Resenhas",
       title = NULL) +
  coord_flip()

df_topicos$site <- as.factor(df_topicos$site)
df_topicos$topico <- as.factor(df_topicos$topico)

cruzamento <- xtabs(~ site + topico, df_topicos)

xtabs(~ site + topico, df_topicos) |> 
  as.data.frame() |>
  ggplot(aes(site, topico)) + 
  geom_tile(aes(fill = Freq)) +
  scale_fill_gradient(low="#D6D2C4", high="#575257")+
  geom_text(aes(label = round(Freq, 1))) +
  labs(x = "Blog", y = "Topicos",
       title = NULL)





