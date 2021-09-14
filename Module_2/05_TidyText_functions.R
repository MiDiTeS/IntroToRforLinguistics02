# Functions
Clean_String <- function(x){
  #Clear accents and diacritics
  temp <- abjutils::rm_accent(x)
  # Clear html 
  temp <- textclean::replace_html(temp, symbol = TRUE)
  # Lowercase
  temp <- tolower(temp)
  # Remove everything that is not a number or letter). 
  # temp <- stringr::str_replace_all(temp,"[^a-zA-Z\\s]", "")
  # Shrink down to just one white space
  temp <- str_squish(temp)
  # remove empity lines
  temp <- na_if(temp,"")
  temp <- na.omit(temp)
  return(temp)
}
