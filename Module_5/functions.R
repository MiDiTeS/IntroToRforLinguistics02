# clean captions

clean_caption <- function(x){
  caption_raw <- caption_to_vector(x)
  n <- length(caption_raw)
  # remove \n from all lines but the last
  caption <- c(stringr::str_remove_all(caption_raw[-n], "[\n].*"),
               caption_raw[n])
  # remove duplicates
  caption <- unique(caption)
  # remove accents
  caption <- abjutils::rm_accent(caption)
  # make it all a single vector
  caption <- paste0(caption, collapse = "\n")
  caption
}
# Extracting metadata
extract.metadata <- function(x, my.file = Sub.folder,
                              fields = fields_raw){
  mat <- str_split(x, "&{3}", simplify = TRUE)
  # create ID and remove the file from the name)
  mat[1,1] <- mat[1,1] %>% str_remove_all(my.file) %>% str_remove_all("/")
  # rename columns
  cols <- fields[1:ncol(mat)]
  colnames(mat) <- cols
  as.tibble(mat)
}

#Creating the data frame 
caption_to_df <- function(x, ...){
  caption <- clean_caption(x)
  meta <- extract.metadata(x, ...)
  meta <- meta %>% 
    mutate(caption = caption)
  meta
}













