#' ---
#' title: "Basic concepts with R (part 1)"
#' author: "| Rodrigo Esteves de Lima-Lopes \n| State University of Campinas \n| rll307@unicamp.br\n"
#' output: 
#'   pdf_document:
#'     number_sections: yes
#'     toc: yes
#'     keep_md: true
#' ---
#' 
## ----setup, include=FALSE--------------

#' 
#' # Introduction
#' In this tutorial we will try to do get some introductory concepts on R language, mostly getting some basic conventions. 
#' 
#' # Some very basic stuff
#' 
#' R is a good arithmetic tool. If we type the following lines in our script and run each at a time:
#' 
#' 
## --------------------------------------
1+5

5-4

100/33

5^2

5**2

9/4

9*4

(300 * 9) + (500 / 2)

x <- 2L
x
typeof(x)

y <- 2.5
y
typeof(y)

z <- 3+2i
z
typeof(z)

h <- "h"
typeof(h)
h

q1 <- TRUE
typeof(q1)
q1

q2 <- FALSE
q2
typeof(q2)

a <- seq(0,100, 2)
a
typeof(a)

repetition <- rep("repetition",100)
repetition

typeof(repetition)

#' 
#' 
#' # In a nutshell
#' 
#' These commands taught us a couple of things:
#' 
#' 1. R can make some basic calculations
#' 1. R can store values in its memory
#'   - But be aware that data is not saved until you tell R to do so
#' 1. We use "<-" for variable attribution
#'   - "=" is also possible, but "<-" is a better choice because
#'     1. "=" is already present inside some commands, so "<-" is exclusive of variable attribution
#'     1. "<-" brings us some direction regarding the attribution
#' 1. There are some kinds of data in R, the basic ones are:
#'   - **Integer**: whole numbers, without decimals
#'   - **Double**: numbers with decimals
#'   - **Complex**: numbers with scientific notation
#'   - **Character**: words or letters
#'   - **Logical** (or Boolean): meaning *TRUE* or *FALSE*
#'   - **Dates**: numbers representing dates
#'   - **Vector**: ordered sequence of numbers or characters
#' 1. Commands in R are always a sequence of letters followed by "()" like `seq()`
#' 1. The way to tell R a value ought to be understood as a  character is to write between quotations marks 
#' 1. Each command might get a set of arguments
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
