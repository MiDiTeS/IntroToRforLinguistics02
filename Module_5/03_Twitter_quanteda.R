writeLines("It is part of my CNPq-funded project and seeks to make corpus tools and R accessible. If you have any doubts or wish to make any research contact please send me an email. Rodrigo de Lima-Lopes rll307@unicamp.br")

# Introduction ------------------------------------------------------------
#Project: Twitter and Quanteda 2
#Objective: 
#By: rll307
#Date: 24/Nov/2021 (Wed)
#Path: Exploratory Twitter Analysis


# packages ----------------------------------------------------------------
library(rtweet)
library(quanteda)
library(quanteda.textstats)
library(quanteda.textplots)
library(ggplot2)



# hashtags ----------------------------------------------------------------
# Lula
tag.LI <- dfm_select(LI.dfm, pattern = ("#*"))
toptag.LI <- names(topfeatures(tag.LI, 50))
tag.fcm.LI <- fcm(tag.LI)
top.plot.LI <- fcm_select(tag.fcm.LI, pattern = toptag.LI)
textplot_network(top.plot.LI, 
                 min_freq = 0.1, 
                 edge_alpha = 0.8, 
                 edge_size = 5,
                 edge_color = "red")


# JB
tag.JB <- dfm_select(JB.dfm, pattern = ("#*"))
toptag.JB <- names(topfeatures(tag.JB, 50))
tag.fcm.JB <- fcm(tag.JB)
top.plot.JB <- fcm_select(tag.fcm.JB, pattern = toptag.JB)
textplot_network(top.plot.JB, 
                 min_freq = 0.1, 
                 edge_alpha = 0.8, 
                 edge_size = 5,
                 edge_color = "orange")



# Users -------------------------------------------------------------------
#Lula
user.LI <- dfm_select(LI.dfm, pattern = ("@*"))
topuser.LI <- names(topfeatures(user.LI, 50))
user.fcm.LI <- fcm(user.LI)
user.plot.LI <- fcm_select(user.fcm.LI, pattern = topuser.LI)
textplot_network(user.plot.LI, 
                 min_freq = 0.1, 
                 edge_alpha = 0.8, 
                 edge_size = 5,
                 edge_color = "red")


user.JB <- dfm_select(JB.dfm, pattern = ("@*"))
topuser.JB <- names(topfeatures(user.JB, 50))
user.fcm.JB <- fcm(user.JB)
user.plot.JB <- fcm_select(user.fcm.JB, pattern = topuser.JB)
textplot_network(user.plot.JB, 
                 min_freq = 0.1, 
                 edge_alpha = 0.8, 
                 edge_size = 5,
                 edge_color = "pink3")











