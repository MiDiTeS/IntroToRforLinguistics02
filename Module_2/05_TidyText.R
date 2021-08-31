
# Packages ----------
# 
library(tidytext)
library(dplyr)
library(readr)
library(tidyverse)
library(tm)
library(tidyr)
library(scales)

## Reading data ----------
### Stopwords
stopwords <- data.frame(read_csv("stop_port2.csv", col_names = FALSE),stringsAsFactors = FALSE)
colnames(stopwords) <- "word"

### Novels
estrela <- readLines("estrela.txt")
paixao <- readLines("paixao.txt")

# creating data frames
estrela <- data.frame(text = estrela, stringsAsFactors = F)
paixao <- data.frame(text = paixao, stringsAsFactors = F)

## creating tidy files
## 
paixao.tidy <- paixao  |>
  unnest_tokens(word, text) |>
  anti_join(stopwords, by ="word")
paixao.l <- paixao.tidy |>
  count(word, sort = TRUE)


estrela.tidy <- estrela  |>
  unnest_tokens(word, text) |>
  anti_join(stopwords, by = "word")

esterla.l <- estrela.tidy |>
  count(word, sort = TRUE)

# Frequency table
frequencia.clarisse <- bind_rows(mutate(paixao.tidy, livro = "P"),
                                 mutate(estrela.tidy, livro = "H"))  |>
  mutate(word = str_extract(word, "[a-z']+"))  |>
  count(livro, word)  |>
  group_by(livro)  |>
  mutate(proportion = (n / sum(n))*100)  |>
  select(-n)  |>
  spread(livro, proportion)

## Visualising ----------
## 
ggplot(frequencia.clarisse, aes(x = H, y = P,
                                color = abs(H - P))) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) + 
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) + 
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) + 
  scale_color_gradient(limits = c(0, 0.001),
                       low = "darkslategray4", high = "gray75") +
  theme(legend.position="none") + 
  labs(y = "Paixão segundo GH", x = "Hora da Estrela")


