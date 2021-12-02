Rodrigo Esteves de Lima Lopes \
*Campinas State University* \
[rll307@unicamp.br](mailto:rll307@unicamp.br)

# Scraping YouTube Comments

# Introduction

This script brings a fast solution to download YouTube comments. Here we are going to integrate R, Python and the base system in a very elegant script. 

## What we need

Some R packages are important for our exercise:

- `magrittr` - for the `%>%` operator
- `jsonlite` - for the manipulation of json files
- `stringr`  - for string manipulation and command building

Outside R we also need: 

- A working installation of [`Python`](https://www.python.org/)
- A working installation of [`youtube-comment-downloader`]( https://github.com/egbertbouman/youtube-comment-downloader)

# Downloading the data

## Preparing the command
We will:

1. Create a variable using the ID of a YouTube Video
1. Create a variable with the file name for our comments
1. Create a command to collect our data


```r
Video.ID <- "FvOO3Gysd7Q"
#File name
File.Name <- 'MourasComments'
#creating a system query
CMD <- str_glue("youtube-comment-downloader --youtubeid {Video.ID} --output {File.Name}.json")
```

## Running it
Now we

1. Check how the command prints
1. Run the command
1. Import the `JSON`file as a dataframe


```r
cat(CMD) # Shows the command
system(CMD) # Actual download
# Importing as a dataframe
Comments <- stream_in(file("MourasComments.json"))
```









