
# title: "Basic concepts with R (part 5)"
# Rodrigo Esteves de Lima Lopes \
# *Campinas State University* \
# [rll307@unicamp.br](mailto:rll307@unicamp.br)

#' 
#' # Introduction
#' 
#' In this tutorial we are going to discuss the one more basic data structure in **R**: lists. I left them to the end because they are the ones I use less frequently in my search. However, they might be important to some packages that use such data structure during their processing. 
#' 
#' # Lists
#' 
#' Lists are **R**'s Swiss knife for data storage and I like to think it as a "meta" data storage facility. In formal terms, a list is an object that can *contain* other objects inside it. The idea is it to serve as an inventory of data, regarding a project or a specific data analysis. 
#' 
#' Let us see it in practical terms. Firstly, Let us create a data frame:
#' 
#' 
## ----------------------------------------------
names <- c('Astolfo', "Eleutério", "Alarico", "Genésia","Gioconda","Ondina")
birthdays <-as.Date(c("1907-06-22","1987-07-12","1941-11-10",
                      "1940-11-15","1910-07-03","1982-06-21"))
gender <-c("male","male",'male', "female","female","female")
life.status <-c(FALSE,TRUE,FALSE,TRUE,FALSE,TRUE)
possible.age <-c(113,33, 79,80,110,38)
my.data.frame <-data.frame(names,birthdays,gender,life.status,possible.age)
colnames(my.data.frame) <-c("Names", 'Birthdays',"Gender","Life.Status",
                            "Possible.Age")

#' 
#' 
#' Secondly, we create a vector:
#' 
## ----------------------------------------------
my.vector <- c("b","r","a","s","i","l")
my.vector

#' 
#' Then a set of single variables:
#' 
## ----------------------------------------------
y <- 2.5
professor <- "Rodrigo"

#' 
#' And, finally a couple of matrices:
#' 
## ----------------------------------------------
columns.names <- c('col1','col2', 'col3')
rows.names <- c('row1','row2','row3','row4','row5')
My.Matrix <- matrix(c(1:15), nrow = 5, byrow = TRUE, dimnames = list(rows.names, columns.names))
columns.names <- c('col1','col2', 'col3')
rows.names <- c('row1','row2','row3','row4','row5')
My.Matrix2 <- matrix(c(15:29), nrow = 5, byrow = TRUE, dimnames = list(rows.names, columns.names))

#' 
#' 
#' Now let us make a list:
#' 
## ----------------------------------------------
My.list <- list(my.vector,My.Matrix,My.Matrix2,professor,y,my.data.frame)
My.list

#' 
#' As we print `my.list` in the console or use the data viewer to have a pic on it, we will see that our data represented as an element of such a list. As any other data we can access, rename, and extract from a list. 
#' 
#' ## Remaning list elements
#' 
#' Our first strategy is to associate a vector to the list's elements, as we do in any other data format:
#' 
## ----------------------------------------------
names(My.list) <- c('my.vector','My.Matrix','My.Matrix2','professor','y','my.data.frame')
My.list

#' 
#' ## Deleting elements in a list
#' 
#' Simple, we delete it as a column in a data frame:
## ----------------------------------------------
My.list[6]<-NULL
My.list

#' 
#' ## Extracting elements from a list. 
#' 
#' We can pull an element and send it to another variable:
#' 
## ----------------------------------------------
My.Matrix3<-My.list[["My.Matrix2"]]
My.Matrix3

#' 
#' Note that it does not delete the data inside the list, only copies it to a new variable. 
#' 
#' 
#' 
