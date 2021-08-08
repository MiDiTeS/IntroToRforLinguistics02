Rodrigo Esteves de Lima Lopes \
*Campinas State University* \
[rll307@unicamp.br](mailto:rll307@unicamp.br)


# Introduction
In this tutorial we will try to do get some introductory concepts on R language, mostly getting some basic conventions. 

# Some very basic stuff

R is a good arithmetic tool. If we type the following lines in our script and run each at a time:



```r
1+5
```

```
## [1] 6
```

```r
5-4
```

```
## [1] 1
```

```r
100/33
```

```
## [1] 3.030303
```

```r
5^2
```

```
## [1] 25
```

```r
5**2
```

```
## [1] 25
```

```r
9/4
```

```
## [1] 2.25
```

```r
9*4
```

```
## [1] 36
```

```r
(300 * 9) + (500 / 2)
```

```
## [1] 2950
```

```r
x <- 2L
x
```

```
## [1] 2
```

```r
typeof(x)
```

```
## [1] "integer"
```

```r
y <- 2.5
y
```

```
## [1] 2.5
```

```r
typeof(y)
```

```
## [1] "double"
```

```r
z <- 3+2i
z
```

```
## [1] 3+2i
```

```r
typeof(z)
```

```
## [1] "complex"
```

```r
h <- "h"
typeof(h)
```

```
## [1] "character"
```

```r
h
```

```
## [1] "h"
```

```r
q1 <- TRUE
typeof(q1)
```

```
## [1] "logical"
```

```r
q1
```

```
## [1] TRUE
```

```r
q2 <- FALSE
q2
```

```
## [1] FALSE
```

```r
typeof(q2)
```

```
## [1] "logical"
```

```r
a <- seq(0,100, 2)
a
```

```
##  [1]   0   2   4   6   8  10  12  14  16  18  20  22  24  26  28  30  32  34  36
## [20]  38  40  42  44  46  48  50  52  54  56  58  60  62  64  66  68  70  72  74
## [39]  76  78  80  82  84  86  88  90  92  94  96  98 100
```

```r
typeof(a)
```

```
## [1] "double"
```

```r
repetition <- rep("repetition",100)
repetition
```

```
##   [1] "repetition" "repetition" "repetition" "repetition" "repetition"
##   [6] "repetition" "repetition" "repetition" "repetition" "repetition"
##  [11] "repetition" "repetition" "repetition" "repetition" "repetition"
##  [16] "repetition" "repetition" "repetition" "repetition" "repetition"
##  [21] "repetition" "repetition" "repetition" "repetition" "repetition"
##  [26] "repetition" "repetition" "repetition" "repetition" "repetition"
##  [31] "repetition" "repetition" "repetition" "repetition" "repetition"
##  [36] "repetition" "repetition" "repetition" "repetition" "repetition"
##  [41] "repetition" "repetition" "repetition" "repetition" "repetition"
##  [46] "repetition" "repetition" "repetition" "repetition" "repetition"
##  [51] "repetition" "repetition" "repetition" "repetition" "repetition"
##  [56] "repetition" "repetition" "repetition" "repetition" "repetition"
##  [61] "repetition" "repetition" "repetition" "repetition" "repetition"
##  [66] "repetition" "repetition" "repetition" "repetition" "repetition"
##  [71] "repetition" "repetition" "repetition" "repetition" "repetition"
##  [76] "repetition" "repetition" "repetition" "repetition" "repetition"
##  [81] "repetition" "repetition" "repetition" "repetition" "repetition"
##  [86] "repetition" "repetition" "repetition" "repetition" "repetition"
##  [91] "repetition" "repetition" "repetition" "repetition" "repetition"
##  [96] "repetition" "repetition" "repetition" "repetition" "repetition"
```

```r
typeof(repetition)
```

```
## [1] "character"
```


# In a nutshell

These commands taught us a couple of things:

1. R can make some basic calculations
1. R can store values in its memory
  - But be aware that data is not saved until you tell R to do so
1. We use "<-" for variable attribution
  - "=" is also possible, but "<-" is a better choice because
    1. "=" is already present inside some commands, so "<-" is exclusive of variable attribution
    1. "<-" brings us some direction regarding the attribution
1. There are some kinds of data in R, the basic ones are:
  - **Integer**: whole numbers, without decimals
  - **Double**: numbers with decimals
  - **Complex**: numbers with scientific notation
  - **Character**: words or letters
  - **Logical** (or Boolean): meaning *TRUE* or *FALSE*
  - **Dates**: numbers representing dates
  - **Vector**: ordered sequence of numbers or characters
1. Commands in R are always a sequence of letters followed by "()" like `seq()`
1. The way to tell R a value ought to be understood as a  character is to write between quotations marks 
1. Each command might get a set of arguments











