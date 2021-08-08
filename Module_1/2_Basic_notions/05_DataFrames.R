# Rodrigo Esteves de Lima Lopes \
# *Campinas State University* \
# [rll307@unicamp.br](mailto:rll307@unicamp.br)


#' 
#' # Introduction
#' 
#' In this tutorial we will work with data frames. On my little experience using R for language analysis, data frames are probably the most useful data structure. It is also important to say that there is a number of operations on data frames that probably will not be covered in this tutorial, mostly because they are so many, that we will learn them along the way. 
#' 
#' # Data Frames
#' 
#' Data frames are matrices like two-dimensional rectangular structures. However, they bring an important difference: data frame columns do not need to be all of the same data kind. In other words, we cam mix up, numbers, characters, logical, date in a complex table. Naturally there are restrictions, since such a freedom concerns only the kind of data represented within each column. for example, in the table that follows:
#' 
#' 
## ---- table_1,echo=FALSE---------------

names <- c('Astolfo', "Eleutério", "Alarico", "Genésia","Gioconda","Ondina")
birthdays <-as.Date(c("1907-06-22","1987-07-12","1941-11-10", "1940-11-15","1910-07-03","1982-06-21"))
gender <-c("male","male",'male', "female","female","female")
life.status <-c(FALSE,TRUE,FALSE,TRUE,FALSE,TRUE)
possible.age <-c(113,33, 79,80,110,38)
my.data.frame <-data.frame(names,birthdays,gender,life.status,possible.age)
colnames(my.data.frame) <-c("Names", 'Birthdays',"Gender","Life.Status","Possible.Age")
my.data.frame

#' 
#' 1. *Names* -> characters
#' 1. *Birthdays* -> date
#' 1. *Gender* -> characters
#' 1. *Life Status* -> logical
#' 1. *Possible age* -> numeric
#' 
#' Let us build this data frame:
#' 
## --------------------------------------
names <- c('Astolfo', "Eleutério", "Alarico", "Genésia","Gioconda","Ondina")
birthdays <-as.Date(c("1907-06-22","1987-07-12","1941-11-10",
                      "1940-11-15","1910-07-03","1982-06-21"))
gender <-c("male","male",'male', "female","female","female")
life.status <-c(FALSE,TRUE,FALSE,TRUE,FALSE,TRUE)
possible.age <-c(113,33, 79,80,110,38)
my.data.frame <-data.frame(names,birthdays,gender,life.status,possible.age)
colnames(my.data.frame) <-c("Names", 'Birthdays',"Gender","Life.Status",
                            "Possible.Age")
my.data.frame

#' 
#' 
#' In the code above:
#' 
#' 1. We created 5 vectors (2 characters, 1 logical, 1 number and 1 date)
#' 1. These vectors were merged into a data frame using the command `data.frame()`
#' 1. When I merge vectors into a data frame, the name of my vectors become the name of the columns
#' 1. The command `colnames()` allows me to change that to a more "clear" set of names.
#'   - Note that the new names is in a vector and it has on name per column, not more, not less. 
#' 
#' 
#' 
#' Now let us check its structure:
#' 
## --------------------------------------
str(my.data.frame)

#' 
#' The command `str()` brings us first idea of our data frame. Besides what we already know, it tells me `my.data.frame` has 6 observations (rows) and 5 variables (columns). Let us try something new:
#' 
#' 
## --------------------------------------
summary(my.data.frame)

#' 
#' The command `summary()` brings a different kind of information:
#' 
#' 1. In **character** columns, it shows the number of observations and the class
#' 1. In  **date** and **numeric** columns it prints the minimum, maximum, median and mean values
#' 1. In **logical** columns it brings the summary of *TRUE* e *FALSE* occurrences
#' 
#' 
#' Some particularities of data frames should be kept in mind:
#' 
#' - The column names cannot be empty
#' - Row names have to be unique
#' - Each column have to consist of same number of items
#' 
#' 
#' # Subetting a data frame
#' 
#' There are some ways of accessing data inside a data frame, here we are going to discuss some
#' 
#' ## Dollar sign ($)
#' 
#' The dollar sign help us to access a column inside a data frame. This is useful for both creating a new variable or telling another command to use that specific data:
#' 
## --------------------------------------
print(my.data.frame$Names)

#' 
#' The beauty of it is that your IDE already recognise the columns and will give you a hand:
#' 
#' ![The dollar sign](./images/DollarSign.png)
#' 
#' 
#' ## Indexing
#' 
#' The index system we learnt to manipulate matrices is also useful for data frames. So we can access specific values inside a matrix. 
#' 
#' 
#' Accessing a single cell
## --------------------------------------
my.data.frame[4,3]
my.data.frame[2,1]

#' 
#' Accessing a line:
#' 
## --------------------------------------
my.data.frame[4,]
my.data.frame[2,]

#' 
#' Accessing a column
#' 
## --------------------------------------
my.data.frame[,4]
my.data.frame[,2]

#' 
#' Accessing and interval of columns
#' 
#' 
## --------------------------------------
my.data.frame[,1:3]

#' 
#' Accessing and interval of rows (also applicable to columns)
#' 
## --------------------------------------
my.data.frame[1:3,]
my.data.frame[1:3,4]

#' 
#' Accessing a couple of columns or rows
#' 
## --------------------------------------
gender.and.age <-my.data.frame[,c(1,3,5)]
gender.and.age 

#' 
#' ## Subset() command
#' 
#' The 'subset()' help us to get information regarding specific values
#' 
## --------------------------------------
women <- subset(my.data.frame, Gender == "female")
women

#' 
#' Combining two subsets
#' 
## --------------------------------------
older.women <- subset(my.data.frame, Gender == "female" & Possible.Age > 50)
older.women

#' 
#' # Expading
#' 
#' Data frames can be expanded in a number of different ways:
#' 
#' ## Addding a column
#' 
#' If we have a vector, we can easily make it a new column using the dollar sign (**$**):
#' 
## --------------------------------------
place.of.birth <-rep("SP",6)
place.of.birth 
my.data.frame$Birthplace <- place.of.birth
my.data.frame

#' 
#' ## Adding a row
#' 
#' Actually it is technically not possible to add new rows. What I have to do is to create a new data frame:
#' 
## --------------------------------------
new.name <- "Esmeralda"
new.Birthday <- as.Date('1930-10-24')
new.gender <-'female'
new.LS <- TRUE
New.age <- 90
newBP <- "RJ"
my.data.frame.2 <- data.frame(new.name,new.Birthday,
                              new.gender,new.LS,New.age,
                              newBP)
colnames(my.data.frame.2) <-c("Names", 'Birthdays',"Gender","Life.Status",
                            "Possible.Age","Birthplace")
my.data.frame.2

#' 
#'  Then merge both by their rows:
#'  
## --------------------------------------
my.data.frame<-rbind(my.data.frame,my.data.frame.2)
my.data.frame

#' 
#' Data frames can also be joined by columns. For example, create a data frame with some new information: 
#' 
## --------------------------------------
Country<- data.frame(rep("Brasil", 7))
colnames(Country)<-"Country"

#' 
#' Then join them:
#' 
## --------------------------------------
cbind(my.data.frame,Country)

#' For more complex data frame operations, please, see the next tutorials. 
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
