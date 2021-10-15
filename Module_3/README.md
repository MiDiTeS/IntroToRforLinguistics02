# README

Rodrigo Esteves de Lima Lopes\
*Campinas State University*\
[rll307@unicamp.br](mailto:rll307@unicamp.br)

# NOTE

Unfortunately, it is not possible to replicate [lima-lopes2020] entirely due to the fact that some of the pieces of news which were the base for the paper are not available at the newspapers' websites or cannot be scraped due to pay wall restrictions. To cope with this problem, I kept an index with the same number of pieces news, but the results will look a bit different. 

These scripts are part of my CNPq-funded project and seeks to make corpus tools and R accessible. If you have any doubts or wish to make any research contact please send me an email. Rodrigo de Lima-Lopes [rll307@unicamp.br](mailto:rll307@unicamp.br)



# Introduction

In this Module I am going to discuss some strategies of comparison between texts and sentiment analysis. It was produced in order to assist colleagues who work in the area of Corpus Linguistics and Systemic Functional Linguistics, as a way to use R in their research. I think that sentiment analysis is an area which needs much work and is disregarded by linguistics. I hope it is a beginning. This is part of my CNPq-funded project and seeks to make corpus tools and network analysis accessible. If you have any doubts or wish to make any research contact please send me an email.

This is the first post is a replication of:

Lima-Lopes, R. E. de. (2020). Immigration and the Context of Brexit: Collocate network and Multidimensional Frameworks Applied to Appraisal in SFL. *Muitas Vozes*, 9(1), 410--441. DOI: 10.5212/MuitasVozes.v.9i1.0024. [URL](https://revistas2.uepg.br/index.php/muitasvozes/article/view/15506).

My general idea is make a full replication, which will take place in five different moments:

1.  01_Sentiment_Data_scraping.md

    -   Data scraping from the news media

2.  02_Sentiment_pre_processing_network.md

    -   Network of words using:

        -   [Quanteda](https://quanteda.io/) [@benoit2018] (an R Package)

        -   [Gephi](https://gephi.org/) [@bastian2009] (a software for networking)

3.  03_Sentiment_Dictionaries.md

    -   Counting the sentiments in each file and in each piece of news

    -   Counting the sentiments in each file and in each newspaper

    -   The categories were predefined by @lima-lopes2020c .

4.   04_Sentiment_plotting_tables.md

    -   Final tables with sentiments

# References
