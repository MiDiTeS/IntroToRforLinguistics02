#' ---
#' title: "Basic concepts with R (part 3)"
#' author: "| Rodrigo Esteves de Lima-Lopes \n| State University of Campinas \n| rll307@unicamp.br\n"
#' output: 
#'   pdf_document:
#'     number_sections: yes
#'     toc: yes
#'     keep_md: true
#' ---
#' 
## ----setup, include=FALSE---------------------

#' 
#' # Introduction
#' 
#' In this tutorial we are going to discuss some data data structure in R. Naturally, vectors are very important, but we need other kind of data if we are going to study language data. Here we are going to discuss matrices. 
#' 
#' # Matrices
#' 
#' A matrix is a bi-dimensional  rectangular data structure, like a more complex vector. The image bellow translates the idea of a matrix in R: 
#' 
#' ![A matrix in R](./images/matrix1.png)
#' 
#' A matrix is bidimensional because it represents data in terms of columns and rows. The rows are represented by the first element in the angle brackets before the comma, while the columns are represented by the second number after the comma, so:
#' 
#' - `[1,]` - represents the first row
#' - `[,4]` - represents the fourth row
#' - `[1,1]` - represents the intersection between the first row and the first column
#' - `[3,4]` - represents the intersection between the third row and the fourth column
#' 
#' 
#' In a matrix, all data have to be on the same format: a matrix contains only characters, or numbers etc. The command we usually create a matrix is:
#' 
#' `matrix(data, nrow, ncol, byrow, dimnames)`
#' 
#' These parameters are:
#' 
#' - **data**: an input vector.
#' - **nrow**: the number of rows.
#' - **ncol**: the number of columns.
#' - **byrow**: logical clue, *TRUE*: input   is arranged by row.
#' - **dimname**:   names assigned to rows columns.
#' 
#' Let us see an example of matrix:
#' 
## ---------------------------------------------
columns.names <- c('col1','col2', 'col3')
rows.names <- c('row1','row2','row3','row4','row5')
My.Matrix <- matrix(c(1:15), nrow = 5, byrow = TRUE, dimnames = list(rows.names, columns.names))
My.Matrix.2 <- matrix(c(1:15), nrow = 5, byrow = FALSE)
My.Matrix.3 <- matrix(c(1:15), nrow = 5, ncol=5, byrow = TRUE)
typeof(My.Matrix)
str(My.Matrix)

#' 
#' We learnt a couple of things from the code above:
#' 
#' 1. The operator "**:**" makes a numerical sequence in *R*
#' 1. The option `byrow = TRUE` distributes the elements by lines
#'   - While `byrow = FALSE` distributes the elements by columns
#' 1. If I create a matrix which needs more that than my input, *R* recycles the data.
#' 1. Vectors were used as input in a function
#' 
#' We can also create a character matrix:
#' 
## ---------------------------------------------
columns.names <- c('col1','col2', 'col3')
rows.names <- c('row1','row2','row3','row4','row5')
my.data.1 <- rep("test", 15)
my.data.2 <- 1:15
my.data.3 <- paste0(my.data.1,my.data.2)
My.Matrix.4 <- matrix(my.data.3, nrow = 5, byrow = TRUE, dimnames = list(rows.names, columns.names))
str(My.Matrix.4)
typeof(My.Matrix.4)

#' 
#' Here we can bring another example of character matrix:
#' 
## ---------------------------------------------
columns.names <- c('col1','col2', 'col3')
rows.names <- c('row1','row2','row3','row4','row5')
My.Data.4 <- letters[seq(from = 1, to = 15 )]
My.Matrix.5 <- matrix(My.Data.4, nrow = 5, byrow = TRUE, dimnames = list(rows.names, columns.names))

#' 
#' Here we learnt some other commands:
#' 
#' - `seq`: creates a sequence of numbers
#' - `letters`: translates the number sequence into letters
#' 
#' As vectors, we can also access elements in a matrix, but each element is now identified for two indexes:
#' 
## ---------------------------------------------
My.Matrix[3,1]
My.Number <- My.Matrix[3,1]
My.Matrix.4[3,1]

#' 
#' The first index refers to the row, while the second to the column. If I leave the number before the coma blank, I will be extracting all elements of a row. If I leave the number after the coma blank, I will be extracting all elements of a column. 
#' 
## ---------------------------------------------
My.Matrix[,1]
My.Matrix[1,]

#' 
#' It is easier to understand if I print this:
#' 
## ---------------------------------------------
My.Matrix.3
My.Matrix.3[,1]
My.Matrix.3[1,]

#' 
#' I can do all sort of operations with matrices, just as I do with vectors:
#' 
## ---------------------------------------------
print(My.Matrix - My.Matrix.2)
print(My.Matrix + My.Matrix.2)
sqrt(My.Matrix)

#' 
#' Note that such operations are recursively. Operations on matrices of different size might through an error.
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
#' 
#' 
#' 
#' 
