######Introdução##########
#Project: Exploração dos programas dos governadores
#Objective: Observar distribuições gerais
#By: rll307
#File: Exploratoria 01

writeLines("It is part of my CNPq-funded project and seeks to make corpus tools and R accessible. If you have any doubts or wish to make any research contact please send me an email. Rodrigo de Lima-Lopes rll307@unicamp.br")
# Pacotes -----------------------------------------------------------------
library(dplyr)
library(tables)
library(ggplot2)
library(data.table)
library(stringr)
library(igraph)
# Dados -------------------------------------------------------------------
candidatos.gov <- readRDS("candidatos_unificado.RDS")

#direcao
# Corrigindo incosistências
candidatos.gov$SG_PARTIDO <- sapply(candidatos.gov$SG_PARTIDO, function(x) gsub("Pode", "PODEMOS", x))
candidatos.gov$SG_PARTIDO <- sapply(candidatos.gov$SG_PARTIDO, function(x) gsub("PODE", "PODEMOS", x))
candidatos.gov$SG_PARTIDO <- sapply(candidatos.gov$SG_PARTIDO, function(x) gsub("SOLIDARIEDADE", "SD", x))

# Colocando a direção (usaremos no final de novo)
candidatos.gov <- candidatos.gov %>%
  mutate(DIRECAO = case_when(
    SG_PARTIDO == 'PMDB' ~ "Centro-direita",
    SG_PARTIDO == 'MDB' ~ "Centro-direita",
    SG_PARTIDO == 'PT' ~ "Esquerda",
    SG_PARTIDO == 'PP' ~ "Direita",
    SG_PARTIDO == 'PSTU' ~ "Esquerda",
    SG_PARTIDO == 'PSD' ~ "Centro-direita",
    SG_PARTIDO == 'PSDB' ~ "Centro-direita",
    SG_PARTIDO == 'PTB' ~ "Centro-direita",
    SG_PARTIDO == 'PROS' ~ "Centro-direita",
    SG_PARTIDO == 'PPL' ~ "Centro-esquerda",
    SG_PARTIDO == 'PT do B' ~ "Centro-direita",
    SG_PARTIDO == 'PTdoB' ~ "Centro-direita",
    SG_PARTIDO == 'AVANTE' ~ "Centro-direita",
    SG_PARTIDO == 'PC do B' ~ "Esquerda",
    SG_PARTIDO == 'PCO' ~ "Esquerda",
    SG_PARTIDO == 'NOVO' ~ "Direita",
    SG_PARTIDO == 'PCdoB' ~ "Esquerda",
    SG_PARTIDO == 'PCB' ~ "Esquerda",
    SG_PARTIDO == 'PSOL' ~ "Esquerda",
    SG_PARTIDO == 'REDE' ~ "Centro-esquerda",
    SG_PARTIDO == 'PSB' ~ "Centro-esquerda",
    SG_PARTIDO == 'PV' ~ "Centro-esquerda",
    SG_PARTIDO == 'PDT' ~ "Centro-esquerda",
    SG_PARTIDO == 'DEM' ~ "Direita",
    SG_PARTIDO == 'PRB' ~ "Direita",
    SG_PARTIDO == 'REPUBLICANOS' ~ "Direita",
    SG_PARTIDO == 'DC' ~ "Direita",
    SG_PARTIDO == 'PSDC' ~ "Direita",
    SG_PARTIDO == 'PATRIOTA' ~ "Direita",
    SG_PARTIDO == 'PHS' ~ "Direita",
    SG_PARTIDO == 'PODE' ~ "Direita",
    SG_PARTIDO == 'Pode' ~ "Direita",
    SG_PARTIDO == 'PODEMOS' ~ "Direita",
    SG_PARTIDO == 'PMN' ~ "Direita",
    SG_PARTIDO == 'PPS' ~ "Direita",
    SG_PARTIDO == 'CIDADANIA' ~ "Direita",
    SG_PARTIDO == 'PMB' ~ "Direita",
    SG_PARTIDO == 'PR' ~ "Direita",
    SG_PARTIDO == 'PRP' ~ "Direita",
    SG_PARTIDO == 'PSC' ~ "Direita",
    SG_PARTIDO == 'PSL' ~ "Direita",
    SG_PARTIDO == 'PTC' ~ "Centro-direita",
    SG_PARTIDO == 'PTN' ~ "Direita",
    SG_PARTIDO == 'SD' ~ "Direita",
    SG_PARTIDO == 'PRTB' ~ "Direita",
    
  ))

# Candidatos por partido

CandPart <- candidatos.gov |>
  select(SG_PARTIDO, ANO_ELEICAO)

CandPart <- CandPart |>
  table() |>
  as.data.frame()

CandPart <- CandPart |>
  subset(Freq > 0)

CandPart <- CandPart[order(CandPart$ANO_ELEICAO),]


ggplot(CandPart, aes(y = Freq, x=SG_PARTIDO, fill = factor(ANO_ELEICAO))) + 
  geom_bar(stat = "identity") +
  scale_y_continuous("Númeo de Candidatos") + 
  scale_fill_manual("Ano da Eleição", values = (c("blue","red")), labels=c('2018',"2014")) +
  theme(axis.text.x = element_text(angle = 60,hjust = 1)) 

# Estados e partidos ------------------------------------------------------
# Válidos e inválidos
aptos <- candidatos.gov[,c("ANO_ELEICAO","SG_UF","SG_PARTIDO","DS_SITUACAO_CANDIDATURA")]

inaptos <- aptos |>
  subset(DS_SITUACAO_CANDIDATURA == "INAPTO") |>
  select(-DS_SITUACAO_CANDIDATURA)
inaptos$ANO_ELEICAO <- as.factor(inaptos$ANO_ELEICAO)

aptos <- aptos |>
  subset(DS_SITUACAO_CANDIDATURA == "APTO") |>
  select(-DS_SITUACAO_CANDIDATURA)
aptos$ANO_ELEICAO <- as.factor(aptos$ANO_ELEICAO)

ggplot(data = aptos, aes(x = SG_UF, y = SG_PARTIDO,color = ANO_ELEICAO, group = 1)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 60,hjust = 1))

ggplot(data = inaptos, aes(x = SG_UF, y = SG_PARTIDO,color = ANO_ELEICAO, group = 1)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 60,hjust = 1))


# UF.Part <- candidatos.gov |>
#   select(ANO_ELEICAO) 

aptos <- candidatos.gov[,c("ANO_ELEICAO","SG_UF","SG_PARTIDO","DS_SITUACAO_CANDIDATURA")]
aptos$ANO_ELEICAO <- as.factor(aptos$ANO_ELEICAO)
aptos$DS_SITUACAO_CANDIDATURA <- as.factor(aptos$DS_SITUACAO_CANDIDATURA)


ggplot(data = aptos, aes(x = SG_UF,
                           y = SG_PARTIDO,
                           color = ANO_ELEICAO,
                           group = 1,
                         shape = DS_SITUACAO_CANDIDATURA)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 60,hjust = 1))

## coligações
#Criando uma rede

coligacao <- candidatos.gov |>
  subset(TP_AGREMIACAO == "COLIGAÇÃO") |>
  select(DS_COMPOSICAO_COLIGACAO)

colnames(coligacao) <- "Node"

coligacao <- as.data.frame(apply(coligacao,2, str_remove_all, " ")) 

colnames(coligacao) <- "Node"
c2 <- coligacao |> 
  tidyr::separate(Node, paste0('Node', c(1:21)), sep = '/', remove = T)


c3 <- rbindlist(lapply(seq(ncol(c2) - 1), function(i) c2[i:(i+1)])) 

c3$Node1 <- toupper(c3$Node1)
c3$Node2 <- toupper(c3$Node2)

c3$Node1 <- gsub("PODE", "PODEMOS", c3$Node1)
c3$Node2 <- gsub("PODE", "PODEMOS", c3$Node2)
c3$Node1 <- gsub("SOLIDARIEDADE", "SD", c3$Node1)
c3$Node2 <- gsub("SOLIDARIEDADE", "SD", c3$Node2)

edges <- c3 |> 
  na.omit()

nodes <- as.vector(c(edges$Node1, edges$Node2)) 
nodes <- data.frame(label = nodes) |>
  unique() 

# Classificando os nodes
rownames(nodes) <- nodes$label

nodes <- nodes |> 
  mutate(DIRECAO = case_when(
  label == 'PMDB' ~ "Centro-direita",
  label == 'MDB' ~ "Centro-direita",
  label == 'PT' ~ "Esquerda",
  label == 'PP' ~ "Direita",
  label == 'PSTU' ~ "Esquerda",
  label == 'PSD' ~ "Centro-direita",
  label == 'PSDB' ~ "Centro-direita",
  label == 'PTB' ~ "Centro-direita",
  label == 'PROS' ~ "Centro-direita",
  label == 'PPL' ~ "Centro-esquerda",
  label == 'PT do B' ~ "Centro-direita",
  label == 'PTdoB' ~ "Centro-direita",
  label == 'PTDOB' ~ "Centro-direita",
  label == 'PCDOB' ~ "Esquerda",
  label == 'AVANTE' ~ "Centro-direita",
  label == 'PC do B' ~ "Esquerda",
  label == 'PCO' ~ "Esquerda",
  label == 'NOVO' ~ "Direita",
  label == 'PCdoB' ~ "Esquerda",
  label == 'PCB' ~ "Esquerda",
  label == 'PSOL' ~ "Esquerda",
  label == 'REDE' ~ "Centro-esquerda",
  label == 'PSB' ~ "Centro-esquerda",
  label == 'PV' ~ "Centro-esquerda",
  label == 'PDT' ~ "Centro-esquerda",
  label == 'DEM' ~ "Direita",
  label == 'PRB' ~ "Direita",
  label == 'REPUBLICANOS' ~ "Direita",
  label == 'DC' ~ "Direita",
  label == 'PSDC' ~ "Direita",
  label == 'PATRIOTA' ~ "Direita",
  label == 'PHS' ~ "Direita",
  label == 'PODE' ~ "Direita",
  label == 'Pode' ~ "Direita",
  label == 'PODEMOS' ~ "Direita",
  label == 'PMN' ~ "Direita",
  label == 'PPS' ~ "Direita",
  label == 'CIDADANIA' ~ "Direita",
  label == 'PMB' ~ "Direita",
  label == 'PR' ~ "Direita",
  label == 'PRP' ~ "Direita",
  label == 'PSC' ~ "Direita",
  label == 'PSL' ~ "Direita",
  label == 'PTC' ~ "Centro-direita",
  label == 'PTN' ~ "Direita",
  label == 'SD' ~ "Direita",
  label == 'PRTB' ~ "Direita",
  
))

colnames(edges) <- c("From","To")

library(igraph)
partidos <- graph_from_data_frame(d = edges, vertices = nodes, directed = FALSE)
print(partidos)
partidos |>
  plot(layout = layout_nicely, edge.arrow.size = 0.2)

## Exporting
colnames(edges) <- c("Source","Target")
nodes$ID <- nodes$label
write.csv(nodes, "nodes.csv", row.names = FALSE)
write.csv(edges, "edges.csv", row.names = FALSE)







 
