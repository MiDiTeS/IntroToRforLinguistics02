# Functions
Clean_String <- function(text){
  #Clear accents and diacritics
  # temp <- abjutils::rm_accent(text)
  # Clear html 
  temp <- text
  temp <- textclean::replace_html(temp, symbol = TRUE)
  temp <- gsub('[[:digit:]]+', ' ', temp)
  # Lowercase
  temp <- tolower(temp)
  # Remove everything that is not a number or letter). 
  #temp <- stringr::str_replace_all(temp,"[^a-zA-Z\\s]", "")
  # Shrink down to just one white space
  temp <- str_squish(temp)
  # remove empty lines
  temp <- na_if(temp,"")
  temp <- na.omit(temp)
  return(temp)
}
