# Rodrigo Esteves de Lima Lopes \
# *Campinas State University* \
# [rll307@unicamp.br](mailto:rll307@unicamp.br)
#'
#' # Introduction
#'
#' You might have observed that some commands showed up in our last tutorial:
#'
#' 1. select()
#' 1. mutate()
#' 1. rename()
#' 1. count()
#' 1. arrange()
#' 1. filter()
#'
#'
#' Each of these commands (and many others, there is an cheatsheet for you) is loaded as we execute `library(dplyr)`. `dplyr` is part of the [`tidyverse`](https://www.tidyverse.org/) collection of packages for data science. They make the task to manipulate data easier than if we were using ordinary R commands. `dplyr` is usually referred as 'a grammar of data manipulation'.
#'
#' However, please, keep in mind that every task in R might be performed in different ways, using different commands or packages.
#'
#' We will discuss here some of the packages utilities, not all. If you need further information, please refer to the [`dplyr` website](https://dplyr.tidyverse.org/) or to the readme at [CRAN](https://cran.r-project.org/web/packages/dplyr/index.html). Remember that after loading the package, you can always type ?+command to get further information.
#'
#' # Using dplyr
#' ## Loading the package
#'
#' We load the package using the following command:
#'
## ----Loading-dplyr----------------------------------------------
library(dplyr)

#'
#' ## Loading data
#' During this tutorial we are going to use `starwars`, a data frame with information regarding the film series (you can tell you professor is a geek). This data frame comes when you load the packages, and it is common that some packages bring some data for training purposes. So, run:
#'
## ---------------------------------------------------------------
head(starwars,10)

#'
#' The data frame brings some basic information about some of the main characters at the series. Here we printed only the 10 first rows. Let us run a `summary()` and a `str()` to check its structure:
#'
## ----str, eval=FALSE--------------------------------------------
## str(starwars)

#'
## ----summary, eval=FALSE----------------------------------------
## summary(starwars)

#'
#' We have pretty long results, but some conclusions might be interesting:
#'
#' - It is a data frame
#' - It has numeric, list and character columns
#' - It has only the seven main movies.
#'
#' ## Filter
#'
#' **Filter** is a command that might be used for filtering data based on a data frame. For example, I will filter all the "droids" in the classical movies:
#'
## ---- filter----------------------------------------------------
head(starwars %>%
       filter(species == "Droid"))

#'
#' *head()* and *tail()* are important commands in **R** language, they will show us the top and bottom **6** lines of any variable I print on my terminal. There is also a second argument, numeric, that my increase or decrease the number of lines. Now let us see all humans.
#'
## ---- humans----------------------------------------------------
head(starwars %>% filter(species == "Human"), 3)

#'
#' Now I have the first three columns. Mind you that the number *3* came in a specific place inside the parenthesis: `command1(command2()3)`. It is so because it is part of `command1()`. The position of the arguments is something we have to keep in mind when we embed commands.
#'
#' Any logical operator can combine into a search:
#'
## ----combined_filter--------------------------------------------

head(starwars %>%
       filter(species == "Human" & hair_color=="none"), 3)

#'
#' ## Select
#'
#' Select help me to get just a couple of information and display it
#'
## ---- select_1--------------------------------------------------
head(starwars %>%
  select(name, ends_with("color")))

#'
#' ## Rename
#' Rename help us to change easily the name of a single column
#'
## ----rename-----------------------------------------------------
head(rename(flights,airline_car = carrier))

#'
#'
#' ## Mutate
#'
#' `mutate()` allows me to create new columns based on some criteria I need. It draws data from existing columns and executes commands to add a new data column in my data frame. For this command let us use another built in R data frame called `nycflights13`:
#'
## ---- loading---------------------------------------------------
library(nycflights13)
summary(flights)

#'
#' If you do not have it installed, please do it. The instructions are in a previous tutorial. `nycflights13` brings all data on Flights in New York airports during the year of 2013, and it is a great tool for training data manipulation. The data brings some information regarding the delays (arrivals and departures). I want a new column that will show me the total of delay a plane might have.
#'
## ----delays-----------------------------------------------------
mutate(flights, total_delay = arr_delay+dep_delay)%>%
  select(total_delay)%>%
  head()

#' Notice that here instead of embedding the command, the *pipe* `%>%` was my syntax choice.
#'
#' If I want to select more than a column I will have to save it as a variable:
#'
## ----more-------------------------------------------------------
delayed_flights <- mutate(flights, total_delay = arr_delay+dep_delay)
head(select(delayed_flights, carrier, total_delay))

#'
#'
#' ## Arrange and filter
#'
#' To discuss arrange and filter I will get back to our previous Gutenberg project data frame:
#'
## ----arramge_filte,eval=FALSE-----------------------------------
## geral.list <- geral.list.df %>%
##   unnest_tokens(word, text) %>%
##   count(word, sort = TRUE) %>%
##   anti_join(my.stopwords, by= "word")%>%
##   mutate((freq = n / sum(n))*100) %>%
##   arrange(desc(freq))
## colnames(geral.list)<-c('word','n','freq')

#'
#' - `anti_join`: excludes whatever is in the column `word` in `my.stopwords` file.
#' - `arrange`: arrange the data according to some criterion, here the column `freq` in descending order.
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
