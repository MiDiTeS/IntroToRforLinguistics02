# Introduction ------------------------------------------------------------
# Name: Replication of Lima-Lopes (2020)
# Source for replication: https://revistas2.uepg.br/index.php/muitasvozes/article/view/15506
# Written by Rodrigo de Lima-Lopes at rll307@unicamp.br
# 
writeLines("It is part of my CNPq-funded project and seeks to make corpus tools and R accessible. If you have any doubts or wish to make any research contact please send me an email. Rodrigo de Lima-Lopes rll307@unicamp.br")

# Packages ----------------------------------------------------------------
library(psych)
#devtools::install_github("ricardo-bion/ggradar", 
#                         dependencies = TRUE)
library(ggradar)
library(scales)

# finding the significance 
News.Cal <- News.Cal[,2:11] |>
  as.matrix()

factors <- factanal(News.Cal, 4, rotation = "promax")
factor.final <- factors[["loadings"]]

# Finding the correlation
correlation <- cor(News.Cal)

#Plotting
ggcorrplot::ggcorrplot(correlation, method = "circle", type = "upper", outline.col = "darkgrey", hc.order = TRUE,insig = "blank",show.diag=FALSE, sig.level=0.05,legend.title = "Corr.", ggtheme=ggplot2::theme_minimal())

# Functions per newspaper -------------------------------------------------

fit2 <- principal(News.Cal, 
                  nfactors = 4, rotate = "cluster")

scores.files <- as.data.frame(fit2[["scores"]])

newspapers <- data.frame(newspapers = c(rep('TT', 27),
                                        rep("TS",21),
                                        rep("DS",50)
))

scores.files <- cbind(newspapers,scores.files)

DS.av <- subset(scores.files, newspapers == "DS", -newspapers)
TT.av <- subset(scores.files, newspapers == "TT", -newspapers)
TS.av <- subset(scores.files, newspapers == "TS", -newspapers)

DS <- t(colMeans(DS.av, na.rm = TRUE))
TT <- t(colMeans(TT.av, na.rm = TRUE))
TS <- t(colMeans(TS.av, na.rm = TRUE))


newspaper <- c("Daily Star", "The Sun", "Telegraph")
dimensions <- c("D1", "D2", "D3","D4")

general.means <- as.data.frame(rbind(DS,TT,TS), row.names = newspaper)

colnames(general.means) <- dimentions

#devtools::install_github("ricardo-bion/ggradar", 
#                         dependencies = TRUE)

radar1 <- general.means %>% 
  as_tibble(rownames = "newspaper") %>% 
  mutate_at(vars(-newspaper), rescale)


ggradar(radar1)
