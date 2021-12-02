Rodrigo Esteves de Lima Lopes \
*Campinas State University* \
[rll307@unicamp.br](mailto:rll307@unicamp.br)


# Scraping YouTube captions


 
# Introduction

This script brings a fast solution to download YouTube captions Here we are going to integrate R, Python and the base system in a very elegant script. 

This script is largely inspired by the work of [Silas Gonzaga](http://sillasgonzaga.com/post/topic-modeling-nathalia-arcuri/), to whom all the credit should be given. 

## What we need

Some R packages are important for our exercise:

- `reticulate` -  Python integration
- `tidyverse` - Data manipulation
- `formattable` - Table manipulation
- `purrr` -  Function mapping
- `magrittr` - for the `%>%` operator
- `jsonlite` - for the manipulation of json files
- `stringr`  - for string manipulation and command building

Outside R we also need: 

- A working installation of [`Python`](https://www.python.org/)
- A working installation of [`youtube-dl`](https://github.com/ytdl-org/youtube-dl). 
-  A working installation of [`Webvtt-py`](https://pypi.org/project/webvtt-py/)


# Creating the base command
Like in the last script, we will create a command to integrate with the system

1) Define the fields

```r
fields_raw <- c("id", "title", "alt_title", "creator", "release_date",
                "timestamp", "upload_date", "duration", "view_count",
                "like_count", "dislike_count", "comment_count")
```

2) Define the fields to be applied to the command


```r
fields <- fields_raw %>% 
  map_chr(~paste0("%(", ., ")s")) %>% 
  # use &&& as field separator
  paste0(collapse = "&&&") %>% 
  # add quotation marks at the end and begging of the string
  paste0('"', ., '"')
```

3) Define the channel URL. Please note it will work with both channels or individual videos


```r
channel_url <- "https://www.youtube.com/channel/UCynXCso-wU6E4V-DnsHU7mA"
```

4) Create the query. Please note that the `str_glue`command makes the *{}* elements to change when the variable changes. 


```r
cmd_ytdl <- str_glue("youtube-dl -o {fields} -i -v -w --skip-download --write-auto-sub --sub-lang pt --sub-format vtt {channel_url}")
```

5) Now we create the final query and the folder where the captions will be downloaded


```r
Sub.folder <- "subtitles"
fs::dir_create(Sub.folder)

cmd <- str_glue("cd {Sub.folder} && {cmd_ytdl}")
system(cmd)
```

- The `fs::dir` creates the directory I declared at `Sub.folder`
- The `system` executes the command on my system. 

6) For cleaning the data we will need

- Map from the system the directory where my files R
- Source a Python script for data cleaning
- Source a R file with some useful functions


```r
my.captions <- dir(Sub.folder, pattern = '*.vtt', full.names = TRUE)
source_python("caption_to_vector.py")
source("functions.R")
```

7) Finally we clean and save it all in a data frame


```r
df <- my.captions %>% 
  map_df(caption_to_df) %>% 
  select(-comment_count) %>% 
  mutate(upload_date = lubridate::ymd(upload_date)) %>% 
  mutate_at(vars(duration:dislike_count), as.numeric)
```



